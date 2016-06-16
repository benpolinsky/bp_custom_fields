Let's say you've got an About Page and a Contact Page to display on website.
The About Page needs to display a bio, some quick contact information, and an image.
The Contact Page needs to display some additional information and would also love to change the labels and submit button values.

We know that neither of these pages will fit nicely in a Page model.  We could serialize a text field with custom attributes, etc.. 
But my interest is to create an abstract Page based on a custom group and custom fields.

Thus:

- Appearances need to take an "Abstract" resource that allows us to enter a custom name of a one off page that will be created.
- We'll then need to dynamically create a view for the admin area, as well as routes, and allow an admin to enter these values.
- Finally, we'll need to come up with a way to load and display the group in a view template. 