<% unless blank_abstract? %>
## Abstract

<%= abstract %>
<% end %>

## Citation

<%= citation %>

## Links

<% if attachments.one? %>
<%= attachments.first.snippet %>
<% else %>
<% attachments.each do |attachment| %>
* <%= attachment.snippet %>
<% end %>
<% end %>
