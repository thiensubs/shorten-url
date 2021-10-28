module ArrayToHash
  extend ActiveSupport::Concern

  class_methods do
    def a_t_h(list, list_attr_get)
      meta_data = [{ current_page: list.current_page, total_pages: list.total_pages, total_items: list.total_entries}]
      list.map! do |e|
        e.as_json(methods: list_attr_get).except('_id', 'created_at', 'updated_at', 'meta_data', 'short_url', 'user_id')
      end
      [list, meta_data]
    end
  end
  # module_function :a_t_h
end
