# require 'rails_helper'
# class AppearanceFieldsSection < SitePrism::Section
#   element :resource_select, '.resource-select select'
#   element :resource_id_field, '.resource-id input[type="text"]'
#   #element :remove_appearance_link, '.remove_fields'
# end
#
# class NewGroupTemplatePage < SitePrism::Page
#   set_url '/custom_fields/group_templates/new'
#
#   element :form, 'form.new_group_template'
#   element :submit_button, 'form.new_group_template input[type="submit"]'
#   element :name_input, 'form.new_group_template .name input[type="text"]'
#   elements :appearance_fields, AppearanceFieldsSection, '.appearance-fields .nested-fields'
#   # elements :custom_fields '.field_template-fields'
# end
#


# First spec when I get back to this:
#   context "using site_prism" do
#     let(:group_template_page) {NewGroupTemplatePage.new}
#
#     before do
#       @first_post = Post.create
#       group_template_page.load
#
#     end
#
#     it "creates without fields" do
#       expect(group_template_page).to have_content "Create a New Custom Field Group"
#       group_template_page.name_input.set "Main Content"
#       expect(group_template_page.appearance_fields.size).to eq 1
#       # group_template_page.appearance_fields.first.resource_select.set "Post"
# #       group_template_page.submit_button.click
#     end
#   end