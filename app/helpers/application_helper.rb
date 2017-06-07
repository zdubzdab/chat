module ApplicationHelper
  def show_link_log_out(user, link)
    link if user.present?
  end

  def show_link_depend_on_user_role(user, links_for_admin, links_for_user)
    if user.nil?
    elsif user.has_role? :admin
      links_for_admin
    else
      links_for_user
    end
  end
end
