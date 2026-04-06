package com.starshop.controller.socket;

import com.starshop.service.ActiveUserTrackerService;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.util.Objects;

@Component
public class WebSocketEventListener {

    private final ActiveUserTrackerService activeUserTrackerService;

    public WebSocketEventListener(ActiveUserTrackerService activeUserTrackerService) {
        this.activeUserTrackerService = activeUserTrackerService;
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = headerAccessor.getSessionId();
        activeUserTrackerService.userLeft(sessionId);
    }
}
