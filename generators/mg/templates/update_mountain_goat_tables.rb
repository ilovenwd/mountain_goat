class UpdateMountainGoatTables < ActiveRecord::Migration

  def self.up
    add_column :converts, :reward, :float, :default => 1.0
    add_column :metric_variants, :reward, :float
    
    rename_table :metric_variants, :mg_metric_variants
    
    Mg::MetricVariant.all.each do |mv|
      mv.update_attribute(:reward, mv.conversions.to_f )
    end
    
    remove_column :metrics, :convert_id
    remove_column :mg_metric_variants, :priority
    
    rename_table :rallies, :mg_rallies
    rename_table :metrics, :mg_metrics
    rename_table :converts, :mg_converts
    rename_table :cs_metas, :mg_cs_metas
    rename_table :ci_metas, :mg_ci_metas
    rename_table :convert_meta_types, :mg_convert_meta_types
    
    create_table "mg_report_items", :force => true do |t|
      t.integer  "report_id"
      t.integer  "reportable_id"
      t.string   "reportable_type"
      t.integer  "order"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "mg_reports", :force => true do |t|
      t.string   "title"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "delivery_set"
      t.string   "recipients"
    end
    
    add_column :mg_converts, :deleted_at, :datetime
    add_column :mg_metrics, :deleted_at, :datetime
    add_column :mg_metric_variants, :deleted_at, :datetime
    add_column :mg_reports, :deleted_at, :datetime
    
    add_column :mg_report_items, :pivot_type, :string
    add_column :mg_report_items, :pivot_id, :integer
    
    add_column :mg_report_items, :filter, :string
    
    add_column :mg_report_items, :meta_type, :string
    add_column :mg_report_items, :meta_id, :integer
    
    add_column :mg_report_items, :extra, :string
    add_column :mg_report_items, :variant, :integer
    add_column :mg_report_items, :subvariant, :integer
    add_column :mg_report_items, :start, :datetime
    add_column :mg_report_items, :end, :datetime
    add_column :mg_report_items, :size, :integer
    
    add_column :mg_reports, :theme, :string
  end

  def self.down
    remove_column :mg_reports, :theme
    
    remove_column :mg_report_items, :extra
    remove_column :mg_report_items, :variant
    remove_column :mg_report_items, :subvariant
    remove_column :mg_report_items, :start
    remove_column :mg_report_items, :end
    remove_column :mg_report_items, :size
    
    remove_column :mg_report_items, :meta_type
    remove_column :mg_report_items, :meta_id
    
    remove_column :mg_report_items, :filter
    
    remove_column :mg_report_items, :pivot_type
    remove_column :mg_report_items, :pivot_id
    
    remove_column :mg_converts, :deleted_at
    remove_column :mg_metrics, :deleted_at
    remove_column :mg_metric_variants, :deleted_at
    remove_column :mg_reports, :deleted_at
    
    rename_table :mg_rallies, :rallies
    rename_table :mg_metrics, :metrics
    rename_table :mg_metric_variants, :metric_variants
    rename_table :mg_converts, :converts
    rename_table :mg_cs_metas, :cs_metas
    rename_table :mg_ci_metas, :ci_metas
    rename_table :mg_convert_meta_types, :convert_meta_types
    
    add_column :metric_variants, :priority, :float
    add_column :metrics, :convert_id, :integer
    remove_column :metric_variants, :reward
    remove_column :converts, :reward
    
    drop_table :mg_reports
    drop_table :mg_report_items
  end

end
