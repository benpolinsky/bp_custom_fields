# !-- in development, not suitable for anything yet -- !

# Problem of hte moment is templates verse implementation
# because you need to store each custom field's many values and where they go.
# in wp, i assume they just get attached to a page or post object
# but we're doing everything by routes...... Ill have to map it out..

# I think its best to switch to 'the rails way' and make it polymorphic.
# each model can be "fieldable" and get that added dynamically or added by the user
# it's a safer way to attach fields, because routes are mutable
# then its just a way of handling fields that dont get attached to anything...

# perhaps make the location optional

# BpCustomFields

There are a number of reasons why I've wanted to use some sort of custom fields in Rails applications:

1. Often my clients want to display content that isn't really tied to any resource.  For instance, a portfolio site:  Where do we stick a field for displaying contact information?  Or an about me paragraph?  Some like to create a Page model, but then you have different attributes for each page: one page requires several images, while another another might need several small snippets of text.  There are other solutions, but my Wordpress development experience wants to reach for custom fields.
2. Settings/Options/Preferences pages.  It's a big question in Rails apps.  Some end up creating a Setting singletonish model or define settings in a .yml file.  I've always found these methods less than fitting solutions.  
3. Content that only gets displayed on certin instances of resources.  Let's say you only want to display a certain field on Post id 10.  Or a post with the slug "breakfast."  You could write some conditional logic in the view, but then you've got a field in your model that's only used for one instance. 
4. Gives a little more control to web admins who aren't rails developers.

### 
- thoughts - hierarchy of fields for repeaters and nested but start simple
- When do we look for custom fields?
  - Default: on each request/page
  - Option to opt in specific actions, controllers, routes
  

- decide whether or not and how to serialize 
- locations.
- jSON?


##### Fields to add
(basically just look at acf pro)

- Color Select
- Better date/datetime selects
- Map?  
