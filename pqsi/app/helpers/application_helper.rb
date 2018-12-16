module ApplicationHelper
  def site_title
    @tag    = (request.path == "/" ? "h1" : "p")
    @title  = content_tag @tag.to_sym, :id => "logo" do
      link_to "PQSI Quality Manager", root_path
    end    
  end
  
  def clear
    content_tag :div, :class => "clear" do
    end
  end
end
