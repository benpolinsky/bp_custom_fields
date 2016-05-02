# !-- in development, not suitable for anything yet -- !
TODO:

- Currently there's a appears_on string on GroupTemplates - make this into an association so it can have_many appearances and conditional logic.  

Apperance
resource:string
resource_id:integer
appears:boolean

Appearance 1 - Appears on All Posts
resource: "post"
resource_id: nil
appears:true 

Appearance 2 - Does not appear on post 23 
resource: "post"
resource_id: 23
appears:false

Together, we'd have a custom_field_group that appears on all posts except 23.  We can continue to build.
Each will need a position, so we can evaulate the logic in order. (rearrange the appearances and we'll show all posts, as the second overrules the first)


# BpCustomFields


There are a number of reasons why I've wanted to use some sort of custom fields in Rails applications:

1. Often my clients want to display content that isn't really tied to any resource.  For instance, a portfolio site:  Where do we stick a field for displaying contact information?  Or an about me paragraph?  Some like to create a Page model, but then you have different attributes for each page: one page requires several images, while another another might need several small snippets of text.  There are other solutions, but my Wordpress development experience wants to reach for custom fields.
2. Settings/Options/Preferences pages.  It's a big question in Rails apps.  Some end up creating a Setting singletonish model or define settings in a .yml file.  I've always found these methods less than fitting solutions.  
3. Content that only gets displayed on certin instances of resources.  Let's say you only want to display a certain field on Post id 10.  Or a post with the slug "breakfast."  You could write some conditional logic in the view, but then you've got a field in your model that's only used for one instance. 
4. Gives a little more control to web admins who aren't rails developers.

### 
- thoughts - hierarchy of fields for repeaters and nested but start simple 
- locations.
- jSON?
- for settings, pages, options, preferences maybe a different gem with custom pages is the way to go
- there's also the option of allowing a route/location based custom field in addition as a quick way to create settings pages...

##### Fields to add
(basically just look at acf pro)

- Color Select
- Better date/datetime selects
- Map?  
