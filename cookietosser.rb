require 'sinatra'

get '/' do
  erb :index, :locals => {:cookies => request.cookies}
end

__END__

@@ layout
<html>
<body>
<%=yield %>
</body>
</html>

@@ index
<ul>
  <% cookies.keys.each do |key| %>
  <li>Cookie named: <%=key%>, value: <%=cookies[key]%></li>
  <% end %>
</ul>