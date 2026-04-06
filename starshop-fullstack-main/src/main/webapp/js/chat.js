document.addEventListener('DOMContentLoaded', function() {
    const chatBubble = document.createElement('div');
    chatBubble.id = 'chat-bubble';
    chatBubble.innerHTML = '<i class="bi bi-chat-dots-fill"></i>';
    document.body.appendChild(chatBubble);

    const chatContainer = document.createElement('div');
    chatContainer.id = 'chat-container';
    chatContainer.style.display = 'none';

    chatContainer.innerHTML = `
        <div id="chat-header">
            <span id="chat-header-title">Trò chuyện</span>
            <div id="admin-chat-button">Chat với Admin</div>
        </div>
        <div id="chat-body">
            <div id="user-sidebar">
                <input type="text" id="user-search-input" placeholder="Tìm hoặc bắt đầu chat..."/>
                <div id="user-list"></div>
            </div>
            <div id="message-area-container">
                <div id="message-area"></div>
                <form id="message-form">
                    <input type="text" id="message-input" autocomplete="off" placeholder="Nhập tin nhắn..."/>
                    <button type="submit">Gửi</button>
                </form>
            </div>
        </div>
    `;

    document.body.appendChild(chatContainer);

    const messageArea = document.getElementById('message-area');
    const messageForm = document.getElementById('message-form');
    const messageInput = document.getElementById('message-input');
    const userListElement = document.getElementById('user-list');
    const userSearchInput = document.getElementById('user-search-input');
    const adminChatButton = document.getElementById('admin-chat-button');

    let stompClient = null;
    // Ensure username is trimmed to avoid whitespace issues in comparison
    let username = typeof loggedInUsername !== 'undefined' ? loggedInUsername.trim() : 'guest' + Math.floor(Math.random() * 1000);
    let activeUsers = new Map(); // username -> displayName (currently online users)
    let chatPartners = new Map(); // username -> {username, displayName} (all partners user has interacted with)
    let currentRecipient = null; // null for public chat
    const ADMIN_USERNAME = "Admin";
    let searchTimeout;

    // Message cache to store history for each recipient
    const messageCache = new Map(); // Key: recipient username (or 'public'), Value: Array of message objects

    chatBubble.addEventListener('click', () => {
        if (typeof loggedInUsername === 'undefined') {
            alert("Bạn cần đăng nhập để sử dụng tính năng chat.");
            return;
        }
        chatContainer.style.display = 'flex';
        chatBubble.style.display = 'none';
        connect();
    });

    document.getElementById('chat-header-title').addEventListener('click', () => {
        chatContainer.style.display = 'none';
        chatBubble.style.display = 'flex';
    });

    function connect() {
        if (stompClient === null) {
            const socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, onConnected, onError);
        }
    }

    async function onConnected() {
        stompClient.subscribe('/topic/public', onPublicMessageReceived);
        stompClient.subscribe('/user/queue/private', onPrivateMessageReceived);
        stompClient.subscribe('/topic/activeUsers', onActiveUsersReceived);
        stompClient.send("/app/chat.addUser", {}, {});
        
        // Initialize chat to public channel
        switchChat(null, 'Trò chuyện chung');

        // NEW: Fetch recent chat partners from backend
        try {
            const response = await fetch('/api/chat/partners');
            if (response.ok) {
                const partners = await response.json();
                partners.forEach(p => {
                    if (p.username !== username) {
                        chatPartners.set(p.username, p);
                    }
                });
                renderUserList(); // Re-render to show initial chat partners
            } else {
                console.error('Failed to fetch recent chat partners', response.status, response.statusText);
            }
        } catch (error) {
            console.error('Error fetching recent chat partners:', error);
        }
    }

    function onError(error) {
        console.error('Could not connect to WebSocket server.', error);
    }

    function sendMessage(event) {
        console.log("DEBUG: sendMessage function called.");
        event.preventDefault(); // Ensure default form submission is prevented
        const messageContent = messageInput.value.trim();
        if(messageContent && stompClient) {
            const chatMessage = { content: messageInput.value, recipient: currentRecipient };
            stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(chatMessage));
            messageInput.value = '';
            
            // Add message to cache immediately for sender's view
            // Ensure 'type' is explicitly set to 'CHAT' for consistency
            const recipientKey = currentRecipient === null ? 'public' : currentRecipient;
            addMessageToCacheAndDisplay({ ...chatMessage, sender: username, type: 'CHAT' }, recipientKey);
        }
    }

    function addMessageToCacheAndDisplay(message, recipientKey) {
        console.log(`DEBUG: Adding message to cache for ${recipientKey}:`, message);
        if (!messageCache.has(recipientKey)) {
            messageCache.set(recipientKey, []);
        }
        messageCache.get(recipientKey).push(message);

        if (currentRecipient === (recipientKey === 'public' ? null : recipientKey)) {
            renderMessage(message);
        }
    }

    function onPublicMessageReceived(payload) {
        const message = JSON.parse(payload.body);
        console.log(`DEBUG: onPublicMessageReceived - message.sender: '${message.sender}', username: '${username}', comparison result: ${message.sender !== username}`);
        // Only add/display if the message is NOT from the current user (to avoid duplicates)
        if (message.sender !== username) {
            addMessageToCacheAndDisplay(message, 'public');
        }
    }

    function onPrivateMessageReceived(payload) {
        const message = JSON.parse(payload.body);
        const recipientKey = (message.sender === username) ? message.recipient : message.sender;
        console.log(`DEBUG: onPrivateMessageReceived - message.sender: '${message.sender}', username: '${username}', comparison result: ${message.sender !== username}`);
        // Only add/display if the message is NOT from the current user (to avoid duplicates)
        if (message.sender !== username) {
            addMessageToCacheAndDisplay(message, recipientKey);
        }

        // If this is a new private chat partner, add them to chatPartners
        if (message.sender !== username && !chatPartners.has(message.sender)) {
            // We need the displayName for the sender. Use activeUsers if available, otherwise just username.
            const senderDisplayName = activeUsers.has(message.sender) ? activeUsers.get(message.sender) : message.sender;
            chatPartners.set(message.sender, { username: message.sender, displayName: senderDisplayName });
            renderUserList(); // Re-render to show new partner
        }
    }

    function onActiveUsersReceived(payload) {
        const participants = JSON.parse(payload.body);
        activeUsers.clear();
        participants.forEach(p => {
            if (p.username !== username) {
                activeUsers.set(p.username, p.displayName);
                // Also add/update in chatPartners if they are active
                chatPartners.set(p.username, p); // Store full participant DTO
            }
        });
        renderUserList(); // Re-render user list whenever active users change
    }

    function renderMessage(message) {
        console.log(`DEBUG: renderMessage called for message:`, message);
        const messageWrapper = document.createElement('div');
        messageWrapper.classList.add('message-wrapper');

        const messageElement = document.createElement('div');
        messageElement.classList.add('chat-message');

        // Check message.type for JOIN/LEAVE messages
        if (message.type === 'JOIN' || message.type === 'LEAVE') {
            messageElement.classList.add('event-message');
            const displayName = activeUsers.get(message.sender) || message.sender;
            messageElement.innerText = displayName + (message.type === 'JOIN' ? ' đã tham gia!' : ' đã rời đi.');
            messageWrapper.appendChild(messageElement);
        } else { // Regular chat message
            if (message.sender === username) {
                messageWrapper.classList.add('my-message');
            } else {
                messageWrapper.classList.add('their-message');
                const senderElement = document.createElement('span');
                senderElement.classList.add('sender-name');
                // Use chatPartners for displayName if available, otherwise activeUsers, then sender username
                const senderDisplayName = chatPartners.has(message.sender) ? chatPartners.get(message.sender).displayName : (activeUsers.get(message.sender) || message.sender);
                senderElement.innerText = senderDisplayName;
                messageWrapper.appendChild(senderElement);
            }

            const textElement = document.createElement('p');
            textElement.innerText = message.content;
            messageElement.appendChild(textElement);
            messageWrapper.appendChild(messageElement);
        }

        messageArea.appendChild(messageWrapper);
        messageArea.scrollTop = messageArea.scrollHeight;
    }

    async function fetchAndDisplayHistory(recipient) {
        const recipientKey = recipient === null ? 'public' : recipient;
        console.log(`DEBUG: fetchAndDisplayHistory called for recipientKey: ${recipientKey}`);

        // If history is already in cache, just render it
        if (messageCache.has(recipientKey)) {
            console.log(`DEBUG: Rendering history from cache for ${recipientKey}. Cache content:`, messageCache.get(recipientKey));
            messageArea.innerHTML = ''; // Clear current view
            messageCache.get(recipientKey).forEach(renderMessage);
            messageArea.scrollTop = messageArea.scrollHeight; // Scroll to bottom
            return;
        }

        // Otherwise, fetch from API
        const url = recipient ? `/api/chat/history/${recipient}` : '/api/chat/history/public';
        console.log(`DEBUG: Fetching history from API: ${url}`);
        try {
            const response = await fetch(url);
            if (response.ok) {
                const history = await response.json();
                console.log(`DEBUG: Received history from API for ${recipientKey}:`, history);
                messageCache.set(recipientKey, history); // Store in cache
                messageArea.innerHTML = ''; // Clear current view
                history.forEach(renderMessage);
                messageArea.scrollTop = messageArea.scrollHeight; // Scroll to bottom
            } else {
                console.error('Failed to fetch chat history', response.status, response.statusText);
            }
        } catch (error) {
            console.error('Error fetching chat history:', error);
        }
    }

    function switchChat(recipient, displayName) {
        console.log(`DEBUG: switchChat called. Recipient: ${recipient}, DisplayName: ${displayName}`);
        currentRecipient = recipient;
        userSearchInput.value = '';

        // Ensure the recipient is in chatPartners
        if (recipient && !chatPartners.has(recipient)) {
            chatPartners.set(recipient, { username: recipient, displayName: displayName });
        }
        
        renderUserList(); // Re-render the user list to highlight active chat and ensure partner is visible
        fetchAndDisplayHistory(recipient);
    }

    // Modified renderUserList to use chatPartners as the primary source
    function renderUserList(searchResultsMap = null) {
        userListElement.innerHTML = '';

        const publicChatElement = createUserListItem(null, 'Trò chuyện chung');
        userListElement.appendChild(publicChatElement);

        let partnersToDisplay = new Map(chatPartners); // Start with all known chat partners

        if (searchResultsMap) { // If search results are provided, display them instead of all chatPartners
            partnersToDisplay = searchResultMap;
        } else { // Otherwise, ensure active users are also in the list
            activeUsers.forEach((displayName, username) => {
                if (!partnersToDisplay.has(username)) {
                    partnersToDisplay.set(username, { username: username, displayName: displayName });
                } else {
                    // Update displayName if activeUsers has a more recent one
                    partnersToDisplay.get(username).displayName = displayName;
                }
            });
        }

        const sortedPartners = Array.from(partnersToDisplay.values()).sort((a, b) => {
            if (a.displayName < b.displayName) return -1;
            if (a.displayName > b.displayName) return 1;
            return 0;
        });

        sortedPartners.forEach(participant => {
            const userElement = createUserListItem(participant.username, participant.displayName);
            userListElement.appendChild(userElement);
        });
    }

    function createUserListItem(recipient, name) {
        const item = document.createElement('div');
        item.classList.add('user-list-item');
        item.dataset.recipient = recipient || 'public';

        const nameSpan = document.createElement('span');
        nameSpan.innerText = name;
        item.appendChild(nameSpan);

        if (recipient && activeUsers.has(recipient)) { // Check activeUsers for online status
            const onlineIndicator = document.createElement('span');
            onlineIndicator.classList.add('online-indicator');
            item.appendChild(onlineIndicator);
        }

        if (currentRecipient === recipient) {
            item.classList.add('active');
        }

        item.onclick = () => switchChat(recipient, name);
        return item;
    }

    async function handleSearch() {
        const query = userSearchInput.value.trim();
        if (query.length === 0) {
            renderUserList(); // Render all known chat partners when search is cleared
            return;
        }
        if (query.length < 2) return;

        try {
            const response = await fetch(`/api/users/search?q=${query}`);
            if (response.ok) {
                const participants = await response.json();
                const searchResultMap = new Map();
                participants.forEach(p => {
                    if (p.username !== username) {
                        searchResultMap.set(p.username, p); // Store ChatParticipantDto
                        // Also add to persistent chatPartners if not already there
                        if (!chatPartners.has(p.username)) {
                            chatPartners.set(p.username, p);
                        }
                    }
                });
                renderUserList(searchResultMap); // Render only search results temporarily
            }
        } catch (error) {
            console.error('Error searching users:', error);
        }
    }

    userSearchInput.addEventListener('input', () => {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(handleSearch, 300);
    });

    messageForm.addEventListener('submit', sendMessage, true);
    adminChatButton.addEventListener('click', () => switchChat(ADMIN_USERNAME, 'Admin'));

    // Expose global functions for chat integration
    window.openChatWindow = function() {
        if (typeof loggedInUsername === 'undefined') {
            alert("Bạn cần đăng nhập để sử dụng tính năng chat.");
            return;
        }
        chatContainer.style.display = 'flex';
        chatBubble.style.display = 'none';
        connect();
    };

    window.startPrivateChat = function(targetUsername, targetDisplayName) {
        window.openChatWindow();
        const checkConnection = setInterval(() => {
            if (stompClient && stompClient.connected) {
                clearInterval(checkConnection);
                // Ensure the target user is added to chatPartners
                if (!chatPartners.has(targetUsername)) {
                    chatPartners.set(targetUsername, { username: targetUsername, displayName: targetDisplayName });
                }
                switchChat(targetUsername, targetDisplayName);
            } else {
                if (stompClient === null) {
                    connect();
                }
            }
        }, 100);
    };
});
