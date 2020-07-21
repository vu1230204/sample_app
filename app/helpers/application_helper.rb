module ApplicationHelper
  def full_title page_title = ""
    base_title = "Rails Tutorial in 14days"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
