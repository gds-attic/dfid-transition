<% unless blank_abstract? %>
## Abstract

<%= abstract %>
<% end %>

## Authors

<% creators.each do |creator| %>
* <%= creator %>
<% end %>

## Citation

<%= citation %>
