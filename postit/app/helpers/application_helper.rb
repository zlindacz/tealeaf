module ApplicationHelper
  def format_url(link)
    link.starts_with?('http://') ? link : 'http://' + link
  end

  def pretty_time(a_time)
    a_time.strftime("%m/%d/%Y %l:%M%p %Z")
  end
end
