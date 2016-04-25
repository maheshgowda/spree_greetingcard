object false
node(:count) { @greetingcards.count }
node(:total_count) { @greetingcards.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page] || Kaminari.config.default_per_page }
node(:pages) { @greetingcards.num_pages }
child(@greetingcards => :greetingcards) do
  extends "spree/api/v1/greetingcards/show"
end
