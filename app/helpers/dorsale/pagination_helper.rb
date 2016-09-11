module Dorsale::PaginationHelper
  def paginate(objects, options = {})
    options = {theme: "twitter-bootstrap-3"}.merge(options)
    super(objects, options).gsub(/>(\s+)</, '><').html_safe
  end
end
