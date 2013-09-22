# ApplicationHelper
module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = t(:yava)
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  # Helper to print text: User has no rights to continue.
  def no_rights
    "<p>#{t(:no_rights)}.<br>
    #{t(:no_rights_please)} #{link_to t(:no_rights_signin), signin_path} #{t(:no_rights_continue)}.</p>".html_safe
  end
  
  # Helper to print text: User can not edit this.
  def no_edit
    "<p>#{t(:no_edit)}.</p>".html_safe
  end
end
