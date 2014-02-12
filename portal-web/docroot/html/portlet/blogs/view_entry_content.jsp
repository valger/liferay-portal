<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/blogs/init.jsp" %>

<%
SearchContainer searchContainer = (SearchContainer)request.getAttribute("view_entry_content.jsp-searchContainer");

BlogsEntry entry = (BlogsEntry)request.getAttribute("view_entry_content.jsp-entry");

AssetEntry assetEntry = (AssetEntry)request.getAttribute("view_entry_content.jsp-assetEntry");
%>
<section>
	<c:choose>
		<c:when test="<%= BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.VIEW) && (entry.isVisible() || (entry.getUserId() == user.getUserId()) || BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.UPDATE)) %>">
			<div class="entry <%= WorkflowConstants.getStatusLabel(entry.getStatus()) %>" id="<portlet:namespace /><%= entry.getEntryId() %>">

				<%
				String strutsAction = ParamUtil.getString(request, "struts_action");
				%>
				<portlet:renderURL var="viewEntryURL">
					<portlet:param name="struts_action" value="/blogs/view_entry" />
					<portlet:param name="redirect" value="<%= currentURL %>" />
					<portlet:param name="urlTitle" value="<%= entry.getUrlTitle() %>" />
				</portlet:renderURL>					
				<div class="imgWpr">
					<aui:a href="<%= viewEntryURL %>">
						<img src="/html/portlet/blogs/img/landscape.png">
						<div class="headerWpr">
							<c:if test='<%= !strutsAction.equals("/blogs/view_entry") %>'>
								<h2><%= HtmlUtil.escape(entry.getTitle()) %></h2>
							</c:if>
						</div>
					</aui:a>
				</div>
				<img src="/html/portlet/blogs/img/profile_picture.png" class="profileImg">
				<p class="name">
					<liferay-ui:message key="written-by" /> : <a href="#"><%= HtmlUtil.escape(PortalUtil.getUserName(entry)) %></a><br>
					<%= dateFormatDateTime.format(entry.getDisplayDate()) %>
				</p>
				
				<c:if test='<%= enableComments %>'>
					<%
					long classNameId = PortalUtil.getClassNameId(BlogsEntry.class.getName());

					int messagesCount = MBMessageLocalServiceUtil.getDiscussionMessagesCount(classNameId, entry.getEntryId(), WorkflowConstants.STATUS_APPROVED);
					if (messagesCount != 0){
					%>
					<div class="comments active">
					<% 
					}
					else{
					%>
					<div class="comments">
					<%
					}
					%>
						<span>
							<c:choose>
								<c:when test='<%= strutsAction.equals("/blogs/view_entry") %>'>
									<%= messagesCount %> 
								</c:when>
								<c:otherwise>
									<aui:a href='<%= PropsValues.PORTLET_URL_ANCHOR_ENABLE ? viewEntryURL : viewEntryURL + StringPool.POUND + "blogsCommentsPanelContainer" %>'><%= messagesCount %></aui:a>
								</c:otherwise>
							</c:choose>
						</span>
					</div>
				</c:if>
				<div class="ratingWpr">
					<c:if test="<%= enableRatings %>">
						<liferay-ui:ratings
							className="<%= BlogsEntry.class.getName() %>"
							classPK="<%= entry.getEntryId() %>"
						/>
					</c:if>		
				</div>
				<c:if test="<%= !entry.isApproved() %>">
					<h3>
						<liferay-ui:message key='<%= entry.isPending() ? "pending-approval" : WorkflowConstants.getStatusLabel(entry.getStatus()) %>' />
					</h3>
				</c:if>

				<portlet:renderURL var="bookmarkURL" windowState="<%= WindowState.NORMAL.toString() %>">
					<portlet:param name="struts_action" value="/blogs/view_entry" />
					<portlet:param name="urlTitle" value="<%= entry.getUrlTitle() %>" />
				</portlet:renderURL>

				<c:if test='<%= enableSocialBookmarks && socialBookmarksDisplayPosition.equals("top") %>'>
					<liferay-ui:social-bookmarks
						displayStyle="<%= socialBookmarksDisplayStyle %>"
						target="_blank"
						title="<%= entry.getTitle() %>"
						types="<%= socialBookmarksTypes %>"
						url="<%= PortalUtil.getCanonicalURL(bookmarkURL.toString(), themeDisplay, layout) %>"
					/>
				</c:if>

				<c:if test="<%= BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.DELETE) || BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.PERMISSIONS) || BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.UPDATE) %>">
					<div class="lfr-meta-actions edit-actions entry">
						<table class="lfr-table">
						<tr>
							<c:if test="<%= BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.UPDATE) %>">
								<td>
									<portlet:renderURL var="editEntryURL">
										<portlet:param name="struts_action" value="/blogs/edit_entry" />
										<portlet:param name="redirect" value="<%= currentURL %>" />
										<portlet:param name="backURL" value="<%= currentURL %>" />
										<portlet:param name="entryId" value="<%= String.valueOf(entry.getEntryId()) %>" />
									</portlet:renderURL>

									<liferay-ui:icon
										image="edit"
										label="<%= true %>"
										url="<%= editEntryURL %>"
									/>
								</td>
							</c:if>

							<c:if test="<%= showEditEntryPermissions && BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.PERMISSIONS) %>">
								<td>
									<liferay-security:permissionsURL
										modelResource="<%= BlogsEntry.class.getName() %>"
										modelResourceDescription="<%= entry.getTitle() %>"
										resourcePrimKey="<%= String.valueOf(entry.getEntryId()) %>"
										var="permissionsEntryURL"
										windowState="<%= LiferayWindowState.POP_UP.toString() %>"
									/>

									<liferay-ui:icon
										image="permissions"
										label="<%= true %>"
										method="get"
										url="<%= permissionsEntryURL %>"
										useDialog="<%= true %>"
									/>
								</td>
							</c:if>

							<c:if test="<%= BlogsEntryPermission.contains(permissionChecker, entry, ActionKeys.DELETE) %>">
								<td>
									<portlet:renderURL var="viewURL">
										<portlet:param name="struts_action" value="/blogs/view" />
									</portlet:renderURL>

									<portlet:actionURL var="deleteEntryURL">
										<portlet:param name="struts_action" value="/blogs/edit_entry" />
										<portlet:param name="<%= Constants.CMD %>" value="<%= TrashUtil.isTrashEnabled(scopeGroupId) ? Constants.MOVE_TO_TRASH : Constants.DELETE %>" />
										<portlet:param name="redirect" value="<%= viewURL %>" />
										<portlet:param name="entryId" value="<%= String.valueOf(entry.getEntryId()) %>" />
									</portlet:actionURL>

									<liferay-ui:icon-delete
										label="<%= true %>"
										trash="<%= TrashUtil.isTrashEnabled(scopeGroupId) %>"
										url="<%= deleteEntryURL %>"
									/>
								</td>
							</c:if>
						</tr>
						</table>
					</div>
				</c:if>

				<div class="entry-footer">

					<div class="stats">
						<c:if test="<%= assetEntry != null %>">
							<span class="view-count">
								<c:choose>
									<c:when test="<%= assetEntry.getViewCount() == 1 %>">
										<%= assetEntry.getViewCount() %> <liferay-ui:message key="view" />,
									</c:when>
									<c:when test="<%= assetEntry.getViewCount() > 1 %>">
										<%= assetEntry.getViewCount() %> <liferay-ui:message key="views" />,
									</c:when>
								</c:choose>
							</span>
						</c:if>
					</div>

					<span class="entry-categories">
						<liferay-ui:asset-categories-summary
							className="<%= BlogsEntry.class.getName() %>"
							classPK="<%= entry.getEntryId() %>"
							portletURL="<%= renderResponse.createRenderURL() %>"
						/>
					</span>

					<span class="entry-tags">
						<liferay-ui:asset-tags-summary
							className="<%= BlogsEntry.class.getName() %>"
							classPK="<%= entry.getEntryId() %>"
							portletURL="<%= renderResponse.createRenderURL() %>"
						/>
					</span>

					<c:if test='<%= displayStyle.equals(BlogsUtil.DISPLAY_STYLE_FULL_CONTENT) || strutsAction.equals("/blogs/view_entry") %>'>
						<c:if test="<%= enableRelatedAssets %>">
							<div class="entry-links">
								<liferay-ui:asset-links
									assetEntryId="<%= (assetEntry != null) ? assetEntry.getEntryId() : 0 %>"
									className="<%= BlogsEntry.class.getName() %>"
									classPK="<%= entry.getEntryId() %>"
								/>
							</div>
						</c:if>
					</c:if>
				</div>
			</div>
		</c:when>
		<c:otherwise>

			<%
			if (searchContainer != null) {
				searchContainer.setTotal(searchContainer.getTotal() - 1);
			}
			%>

		</c:otherwise>
	</c:choose>
</section>