class HomeController < ApplicationController
  def index
    @custom_fields = BpCustomFields.all
  end
  
  def post
    @post = Post.find(params[:id])
    @custom_fields = @post.custom_fields # sends back a flat map of all custom fields (not nested in groups)
    @custom_field_groups = @post.groups_and_fields # sends back a group_by type hash of groups and fields nested
    @specific_field = Post.find_fields('field_name') # find specific field
    @specific_field_in_group = Post.find_fields(group: 'group_name', field: 'field_name') # find specific field in group
    @specific_group = Post.find_group('group name') # find specific group
    
  end
end