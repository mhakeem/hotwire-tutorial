This repo follows the Hotwire tutorial in https://www.hotrails.dev/turbo-rails. Below are the instructions on installing and running the app, and some helpful (to me) direct quotes from the tutorial site.

## Instructions to install and run the app

### System requirements

- Linux or MacOS
- Ruby 3.1.2
- Rails 7.0.4.3
- Node.js 16+
- Docker
- PostgreSQL 13+ (if not running docker)
- Redis 6+ (if not running docker)

### To run the app

- Run `bundle install`
- Open another terminal tab/window and run `docker compose up`
  - If you don't want to use docker, install and run PostgreSQL and Redis on your machine independently
- To prepare the DB, run `bin/setup`
- To start the app, run `bin/dev`

### To run the test suite

- Prepare the DB `RAILS_ENV=test bin/rails db:test:prepare`
- For running only e2e tests, run `bin/rails test:system`
- For running all tests, run `bin/rails test:all`

## Quotes and notes from the tutorial

### What are Turbo Frames?

Turbo Frames are independent pieces of a web page that can be **_appended, prepended, replaced, or removed_** without a complete page refresh and writing a single line of JavaScript!

### Turbo Frames Rules

1. **Rule 1:** When clicking on a link within a Turbo Frame, Turbo expects a frame of the same id on the target page. It will then replace the Frame's content on the source page with the Frame's content on the target page.

2. **Rule 2:** When clicking on a link within a Turbo Frame, if there is no Turbo Frame with the same id on the target page, the frame disappears, and the error Response has no matching `<turbo-frame id="name_of_the_frame">` element is logged in the console.

3. **Rule 3:** A link can target another frame than the one it is directly nested in thanks to the `data-turbo-frame` data attribute.

### About `_top`

- There is a special frame called `_top` that represents the whole page. It's not really a Turbo Frame, but it behaves almost like one, so we will make this approximation for our mental model.
- To replace the whole page, we could use `data-turbo-frame="_top"`
- When using the "\_top" keyword, the URL of the page changes to the URL of the target page, which is another difference from when using a regular Turbo Frame.

### dom_id

These codes do the same thing:

```erb
<%= turbo_frame_tag "quote_#{@quote.id}" do %>
  ...
<% end %>

<%= turbo_frame_tag dom_id(@quote) do %>
  ...
<% end %>

<%= turbo_frame_tag @quote %>
  ...
<% end %>
```

### Turbo Stream

#### Helper methods

```ruby
# Remove a Turbo Frame
turbo_stream.remove

# Insert a Turbo Frame at the beginning/end of a list
turbo_stream.append
turbo_stream.prepend

# Insert a Turbo Frame before/after another Turbo Frame
turbo_stream.before
turbo_stream.after

# Replace or update the content of a Turbo Frame
turbo_stream.update
turbo_stream.replace
```

Of course, except for the `remove` method, the `turbo_stream` helper expects a partial and locals as arguments to know which HTML it needs to append, prepend, replace from the DOM. In the next section, we will learn how to pass partials and locals to the `turbo_stream` helper.

#### Real-time updates

For real time updates, we add the following:

1. In a model, add `after_<action>_commit` hook
   - include the broadcast function to an ActionCable channel
   - include a partial to render
   - include locals to pass the variable(s) to the partial
   - target the HTML element ID that will be updated which could be a div or a turbo_frame_tag
     - if you don't include the target, it is expected that the target ID would be a plural of a model name
     - if you don't include the partial, locals, and target, therefore it is expected that all of those follow Rails naming convention and will be automatically included during runtime

```ruby
# here we explicitly declare the HTML element target ID
after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }

# or we can omit the target if the HTML element's ID would be a model's plural name, which is "quotes" in this example
after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self } }

# or we can omit partial, locals, and target if they all match the model and its controller's Rails naming convention
after_create_commit -> { broadcast_prepend_to "quotes" }
```

2. Add the the `turbo_stream_from "channel_name"` in your view

```erb
<%= turbo_stream_from "quotes" %>
```

If you want to broadcast CRUD, there is a single line that does all that:

```ruby
# after_create_commit -> { broadcast_prepend_later_to 'quotes' }
# after_update_commit -> { broadcast_replace_later_to 'quotes' }
# after_destroy_commit -> { broadcast_remove_to 'quotes' }
# Those three callbacks are equivalent to the following single line
broadcasts_to ->(quote) { 'quotes' }, inserts_by: :prepend
```

#### When to use `<turbo-frame>` tag or a `<div>`

- We must use a Turbo Frame when we need Turbo to intercept clicks on links and form submissions for us.
- On the other hand, we don't need a Turbo Frame when we only target an id of the DOM in a Turbo Stream view.
