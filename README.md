# !-- in development, not suitable for anything yet -- !


# BpCustomFields
1. More Hierarchy fields 
2. Everything orderable (esp fields)
3. audio (how are you handling this? - soundmanger or just leave it up to user for now... (maybe eliminate type...)
4. errors and notifications
5. How to handle default style... default theme, perhaps.
6. toolbar full/complex/none - how to pass to js


There are a number of reasons why I've wanted to use some sort of custom fields in Rails applications:

1. Often my clients want to display content that isn't really tied to any resource.  For instance, a portfolio site:  Where do we stick a field for displaying contact information?  Or an about me paragraph?  Some like to create a Page model, but then you have different attributes for each page: one page requires several images, while another another might need several small snippets of text.  There are other solutions, but my Wordpress development experience wants to reach for custom fields.
2. Settings/Options/Preferences pages.  It's a big question in Rails apps.  Some end up creating a Setting singletonish model or define settings in a .yml file.  I've always found these methods less than fitting solutions.  
3. Content that only gets displayed on certin instances of resources.  Let's say you only want to display a certain field on Post id 10.  Or a post with the slug "breakfast."  You could write some conditional logic in the view, but then you've got a field in your model that's only used for one instance. 
4. Gives a little more control to web admins who aren't rails developers.

### 
- hierarchy of fields for repeaters and nested (ancestry)
- locations.
- jSON?
- for settings, pages, options, preferences maybe a different gem with custom pages is the way to go
- there's also the option of allowing a route/location based custom field in addition as a quick way to create settings pages...

##### Fields to add



REPEATER

Field Template - Repeater
Parent Field - groups fields together and acts as anchor - value is probably blank
Children Fields - Each field_template can be changed.  


TABS
Parent Field - Acts as anchor
1st Children - First set of children are the layout for each tab
2nd Children - these are the fields within each.


FLEX CONTENT - Later!  Will have to think about this after you implement everything else.


- Gallery
- Color Select
- Map?
- Better date/datetime selects
- oEmbed (replace video?)

Layout:
 - Flexible Content
 - Repeater
 - Tab

Relational:
  Page Link/Route
  Resource or instance
  Relationship
  Tags


##### Options to add

- more validations
- custom classes


## brainstorming on instructions...

1. add to gemfile
2. bundle
3. Mount engine in routes (can be automated in install?)
4. Install Migrations/Rake db (1/2 automated in install)
4. Add include BpCustomFields::Fieldable to models (could generate rake task)
5. Add display_custom_fields helper to forms
5. Add strong_parameters to controller
6. Probably want to add javascripts (and css?) to your file

## query methods

    Resource.find_fields('field name')
    Resource.find_groups
    
    @resource.groups_and_fields
    @resource.custom_fields




## display helpers
  


## Appearances

#### An Appearance is a way to reference a resource, a collection, or conditional queries (and soon random locations not tied to any resource)

- An Appearance takes the name of a resource/model as a string
- An Appearance optionally takes an id to target a specific record
- Appearances are additive by default, but you can subtract from each other by setting appears to false

TODO: Examples!