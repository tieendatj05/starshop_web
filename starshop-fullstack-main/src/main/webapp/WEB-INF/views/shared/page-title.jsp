<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Reusable page-title block
  Usage examples:
    <c:set var="pageTitle" value="Đăng ký" />
    <c:set var="showDivider" value="true" />
    <jsp:include page="/WEB-INF/views/shared/page-title.jsp" />

  Optional variables you can set before include:
    - pageTitle (required to render)
    - pageSubtitle (optional)
    - titleClass (optional) e.g. "h3 mb-1" or "display-5 fw-bold"
    - titleTag (optional) one of: h1, h2, h3 (defaults to h1)
    - subtitleClass (optional) default: "text-muted small"
    - wrapperClass (optional) default: "page-title-wrapper text-center my-4"
    - showDivider (optional boolean) default: false
    - dividerClass (optional) default: "section-divider"
--%>

<c:choose>
    <c:when test="${not empty pageTitle}">
        <c:if test="${empty titleClass}"><c:set var="titleClass" value=""/></c:if>
        <c:if test="${empty subtitleClass}"><c:set var="subtitleClass" value="text-muted small"/></c:if>
        <c:if test="${empty wrapperClass}"><c:set var="wrapperClass" value="page-title-wrapper text-center my-4"/></c:if>
        <c:if test="${empty titleTag}"><c:set var="titleTag" value="h1"/></c:if>
        <c:if test="${empty showDivider}"><c:set var="showDivider" value="false"/></c:if>
        <c:if test="${empty dividerClass}"><c:set var="dividerClass" value="section-divider"/></c:if>

        <div class="${wrapperClass}">
            <c:choose>
                <c:when test="${pageTitle != null and titleTag == 'h1'}">
                    <h1 class="${titleClass} gradient-text animated-gradient text-uppercase">${pageTitle}</h1>
                </c:when>
                <c:when test="${pageTitle != null and titleTag == 'h2'}">
                    <h2 class="${titleClass} gradient-text animated-gradient text-uppercase">${pageTitle}</h2>
                </c:when>
                <c:when test="${pageTitle != null and titleTag == 'h3'}">
                    <h3 class="${titleClass} gradient-text animated-gradient text-uppercase">${pageTitle}</h3>
                </c:when>
                <c:otherwise>
                    <h1 class="${titleClass} gradient-text animated-gradient text-uppercase">${pageTitle}</h1>
                </c:otherwise>
            </c:choose>

            <c:if test="${showDivider}">
                <div class="${dividerClass}"></div>
            </c:if>

            <c:if test="${not empty pageSubtitle}">
                <p class="${subtitleClass}">${pageSubtitle}</p>
            </c:if>
        </div>
    </c:when>
    <c:otherwise>
        <!-- no title provided -->
    </c:otherwise>
</c:choose>
