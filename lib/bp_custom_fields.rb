require 'bp_custom_fields/version'
require "bp_custom_fields/engine"
require 'bp_custom_fields/railtie' if defined?(Rails)
require 'bp_custom_fields/fieldable'
require 'bp_custom_fields/field_manager'
require 'bp_custom_fields/query_methods'
require 'bp_custom_fields/video'

module BpCustomFields
  EXCLUDED_MODELS = [
    "ActiveRecord::SchemaMigration", 
    'BpCustomFields::GroupTemplate', 
    'BpCustomFields::Group', 
    'BpCustomFields::Appearance',
    'BpCustomFields::Field',
    'BpCustomFields::FieldTemplate'
  ]
  
  
  # this is...not great...... and now disgusting... will be able to figure this out
  # once i remove sub groups
  # the problem is that a field can have sub_groups and repeater groups have fields etc...
  # we need to repeat both the fields_attributes and the sub_group_attributes
  
  # so, I think we have two differnet 'bases' and attach each?
  PROTECTED_ATTRIBUTES = {
    groups_attributes: [
      :id, :group_template_id, :_destroy, fields_attributes:[
        :id, :value, :file, :field_template_id, :_destroy, value: [], children_attributes: [
          :id, :value, :file, :field_template_id, :parent_id, :_destroy, value: [], children_attributes: [
            :_destroy, :id, :value, :file, :field_template_id, :parent_id, :_destroy, value: [],
            sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
              :id, :value, :file, :_destroy, :field_template_id, value: [], children_attributes: [
                :_destroy, :id, :value, :file, :_destroy, :field_template_id, :parent_id, value: []
                ],
                sub_groups_attributes: [:_destroy, :id, :_destroy, :is_sub_group, :parent_field_id, fields_attributes: [
                  :id, :value, :file, :_destroy, :field_template_id, value: [], children_attributes: [
                    :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
                    ],
                    sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
                      :_destroy, :id, :value, :file, :field_template_id, value: [], children_attributes: [
                        :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
                        ],
                        sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
                          :_destroy, :id, :value, :file, :field_template_id, value: [], children_attributes: [
                            :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
                            ],
                            sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
                              :_destroy, :id, :value, :file, :field_template_id, value: [], children_attributes: [
                                :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
                                ]
                            ]
                        ]
                    ]]
                ]]
            ]]
            ]
            ]
          ]
          ],
        sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
          :_destroy, :id, :value, :file, :field_template_id, value: [], children_attributes: [
            :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
            ],
            sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
              :_destroy, :id, :value, :file, :field_template_id, value: [], children_attributes: [
                :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
                ],
                sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
                  :_destroy, :id, :value, :file, :field_template_id, value: [], children_attributes: [
                    :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
                    ],
                    sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
                      :_destroy, :id, :value, :file, :field_template_id, value: [], children_attributes: [
                        :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
                        ],
                        sub_groups_attributes: [:_destroy, :id, :is_sub_group, :parent_field_id, fields_attributes: [
                          :_destroy, :id, :value, :file, :field_template_id, value: [], children_attributes: [
                            :_destroy, :id, :value, :file, :field_template_id, :parent_id, value: []
                            ]
                        ]
                    ]
                ]]
            ]]
        ]]
        ]
        ]
      ]
      ]
    }
end