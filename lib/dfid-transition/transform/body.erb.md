<% unless blank_abstract? %>
## Abstract

<%= abstract %>
<% end %>

## Citation

<%= citation %>

## Links

<% attachments.each do |attachment| %>
<%= attachment.snippet %>
<% end %>
