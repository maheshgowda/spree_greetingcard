object false
node(:attributes) { [*greetingcard_attributes] }
node(:required_attributes) { required_fields_for(Spree::Greetingcard) }
