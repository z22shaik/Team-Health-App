module ApplicationHelper
    # reference for sort: http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast
    def sortable(column, title = nil)
        title ||= column.titleize
        direction = (column == Team.sort_column(params) && Team.sort_direction(params) == "asc") ? "desc" : "asc"
        link_to( title, teams_path( :sort => column, :direction => direction) )
    end

     # reference for sort: http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast
     def sortableUsers(column, title = nil)
        title ||= column.titleize
        direction = (column == User.sort_column(params) && User.sort_direction(params) == "asc") ? "desc" : "asc"
        link_to( title, users_path( :sort => column, :direction => direction) )
    end

    def sortable_feedbacks(column, title = nil)
        title ||= column.titleize
        direction = (column == Feedback.sort_column_feedbacks(params) && Feedback.sort_direction_feedbacks(params) == "asc") ? "desc" : "asc"
        link_to( title, feedbacks_path(:sort => column, :direction => direction) )
    end

    def sortable_user_roles(column, title = nil)
        title ||= column.titleize
        direction = (column == User.sort_column_role(params) && User.sort_direction(params) == "asc") ? "desc" : "asc"
        link_to( title, users_path( :sort => column, :direction => direction) )
    end

    def sortable_users_by_teams(column, title = nil)
        title ||= column.titleize
        direction = (column == User.sort_column_team(params) && User.sort_direction(params) == "asc") ? "desc" : "asc"
        link_to( title, users_path( :sort => column, :direction => direction) )
    end

end