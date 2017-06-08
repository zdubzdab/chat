module ApplicationHelper
  def show_link_log_out(user, link)
    link if user.present?
  end

  def show_link_depend_on_user_role(user, links_for_admin, condition_for_admin,
                                    links_for_user, condition_for_user)
    if user.nil?
    elsif user.has_role? :admin
      show_link_on_desired_page(links_for_admin, condition_for_admin)
    else
      show_link_on_desired_page(links_for_user, condition_for_user)
    end
  end

  def time_fomat(time)
    time.strftime('%A, %b %d, %Y at %I:%M%p')
  end

  def patch_depend_on_url(condition, user)
    if condition
      [:admin, user]
    else
      user
    end
  end

  private

  def show_link_on_desired_page(link, condition)
    link unless condition
  end
end
