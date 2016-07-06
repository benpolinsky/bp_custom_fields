Top priority (from el's site)

- still wondering about that carrierwave bug...

# !-- in development, not suitable for anything yet -- !
-- reordering (creation form)
-- automatically create label as you type in name
-- deeper validations, both when a user makes a field required, and what should be required for different field types - custom validator time.
  - Repeaters, min and max
  - Flex content min and max?
-- Tabs + Repeaters:  figure out what to include (more tabs, repeaters, flex... etc)
-- Tabs: if you should make them more like repeatables or layouts... (so you're effectively declaring a tab group field.)
-- child_field_templates and _field_template_fields partials/views are nearly identical.... refactor  
-- replace field partials with helpers - it takes too long to render all of them
-- Flex content - More layout options (min + max, add row label override)
- "No Fields - click add ____ to add " message if no fields in current level
- abstract_resource creationn - must use lowercase in appearance - change that
- abstract resource slug

# BpCustomFields

1. More Hierarchy field work - flex content -> check?
2. Everything orderable (esp fields) -> check?
3. audio (how are you handling this? - soundmanger or just leave it up to user for now... (maybe eliminate type...)
4. errors and notifications
5. toolbar full/complex/none - how to pass to js
6. namespace all css classes etc
7. Files, consider: http://mailru.github.io/FileAPI/ 
8. Lots of the JS should be combined, probably all of it into a class

There are a number of reasons why I've wanted to use some sort of custom fields in Rails applications:

1. Often my clients want to display content that isn't really tied to any resource.  For instance, a portfolio site:  Where do we stick a field for displaying contact information?  Or an about me paragraph?  Some like to create a Page model, but then you have different attributes for each page: one page requires several images, while another another might need several small snippets of text.  There are other solutions, but my Wordpress development experience wants to reach for custom fields.
2. Settings/Options/Preferences pages.  It's a big question in Rails apps.  Some end up creating a Setting singletonish model or define settings in a .yml file.  I've always found these methods less than fitting solutions.  
3. Content that only gets displayed on certin instances of resources.  Let's say you only want to display a certain field on Post id 10.  Or a post with the slug "breakfast."  You could write some conditional logic in the view, but then you've got a field in your model that's only used for one instance. 
4. Content that's displayed on multiple resources.. Sure you could create polymorphic model, but what if you're adding
5. Gives a little more control to web admins who aren't rails developers, and that's one of the main goals I'd like to reach toward in terms of my rails development: how can we make rails apps as dynamic as possible, even after transferred to the client.


Much credit goes to ACF and its creator @elliotcondon for the inspiration.  Wordpress and Rails are different beasts, and so while ACF relies on serialization of attributes in wordpress' main table (posts?), we're able to mvc this a bit more.
Nonetheless, his project has completely 100% guided my approach, especially the UX.

Thanks to the fabulous Cocoon gem from @nathanvda which bp_custom_fields heavily relies upon.

### 
- hierarchy of fields for repeaters and nested
- locations.
- jSON?
- for settings, pages, options, preferences maybe a different gem with custom pages is the way to go
- there's also the option of allowing a route/location based custom field in addition as a quick way to create settings pages...

##### Fields to add



- REPEATER
  - look out for edge cases involved with updating fields that are already attached to existing resources
  - for the user side, when filling in nester repeater values, right now I'm hard coding in a max of 10 levels
  - the recursive partial rendering needs to know when to stop because it prerenders



- FLEX CONTENT
 

Field side - we need to store:

Field that corresponds to flexible_content holds a value indicating which layout was chosen
Field's children each hold a value responding to the type of each layouts children type


====


- Gallery
- Color Select
- Map?
- Better date/datetime selects
- oEmbed (replace video?)

Layout:
 - Repeater - polishing needed, but check
 - Tab - polishing neeeded, but check
 - Flexible Content - polishing needed, but check
 
Relational:
  Page Link/Route
  Resource or instance
  Relationship?
  Tags


##### Options to add

- more validations
- custom classes
- dropzone to files

## brainstorming on instructions...

1. add to gemfile
2. bundle
3. Mount engine in routes (can be automated in install?)
4. Install Migrations/Rake db (1/2 automated in install)
4. Add include BpCustomFields::Fieldable to models (could generate rake task)
5. Add display_custom_fields helper to forms
5. Add strong_parameters to controller
6. Probably want to add javascripts (and css?) to your file

## API

    field = BpCustomFields.find_field('field_name', @resource) # BpCustomFields::Field
    group = BpCustomFields.find_group('group', @resource)      # BpCustomFields::Group
    
    field.display # display via sensible default, ie, iterate through repeaters, show an image, display link to file
    field.value # raw value, either file or text value.
    
    # fileables - images, other files are 'fileable'

    field = BpCustomFields.find_field('file field', @resource) # BpCustomFields::Field
    field.field_type == 'file' # true
    field.fileable?            # true
    field.file                 # access file 
    field.absolute_url         # url with full host/domain
    
    
    Resource.find_fields('field name')
    Resource.find_groups
    
    @resource.groups_and_fields
    @resource.custom_fields
    
    
## Liquid?

Because drops are lazily loaded, the idea is just to load this sucker up with drops
till the cows come home.  Everything the designer/client might need gets a drop.


I still need to be able to do something like this, somehow..

{% for product in product %}
  {{product.get_custom_field('field name')}}
{% endfor %}



## display helpers
  
# Importing and Exporting would be nice

## Appearances

#### An Appearance is a way to reference a resource, a collection, or conditional queries (and soon random locations not tied to any resource)

- An Appearance takes the name of a resource/model as a string
- An Appearance optionally takes an id to target a specific record
- Appearances are additive by default, but you can subtract from each other by setting appears to false

TODO: Examples!

- Perhaps a walk-through using [shepherd](http://github.hubspot.com/shepherd/docs/welcome/)