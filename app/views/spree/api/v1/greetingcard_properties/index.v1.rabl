object false
child(@greetingcard_properties => :greetingcard_properties) do
  attributes *greetingcard_property_attributes 
end
node(:count) { @greetingcard_properties.count }
node(:current_page) { params[:page] || 1 }
node(:pages) { @greetingcard_properties.num_pages }
