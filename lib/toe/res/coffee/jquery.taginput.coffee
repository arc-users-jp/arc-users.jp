$ = jQuery

$.fn.taginput = (options) ->
  @each ->
    unless (x=$(@)).data('taginput')
      x.data('taginput', new TagInput(@, options))

class TagInput

  defaults =
    source      : []
    #autocomplete : {}
    lowercase   : no
    separator   : ','
    duplicates  : no
    minLength   : 1
    maxLength   : 140
    onAdd       : $.noop
    onRemove    : $.noop
    onDuplicate : -> @input.focus()
    onInvalid   : -> @input.focus()
    onReady     : $.noop

  constructor: (element, options) ->
    @options   = $.extend(defaults, options)
    @separator = new RegExp(@options.separator, 'g')
    @focused   = no
    @index     = []
    @origin    = $(element).addClass('taginput-origin').hide()
    @field     = $('<div class="taginput">
                      <ul>
                        <li class="new">
                          <input autocomplete="off" tabindex="0" type="text">
                        </li>
                      </ul>
                    </div>')
    @input     = @field.find('input').css('width', '1em')

    @origin.before(@field)

    @field.on
      click: (e) =>
        @focus()
        @input.focus()
        no

    @input.on
      keyup: (e) =>
        @input.css('width', "#{ @input.val().length+1 }em") # TODO
        @add(v) if (v=@input.val()).match(@separator)

      focus: (e) =>
        @input.focused = yes
        @deselect()
        @focus()

      blur: (e) =>
        @input.focused = no
        @blur if @input.val().length is 0

    if source=@options.source
      @input.typeahead
        source: if typeof source is 'string'
                  (q, cb) -> $.get(source, {query: q}, (res) -> cb(res))
                else
                  source

        updater: (item) => @add(item)

    #------------------------------
    $(document).on
      click: (e) =>
        @add(@input.val())
        @blur()

      keydown: (e) =>
        return yes unless @focused
        return yes if @options.source &&
                      $('.typeahead.dropdown-menu').css('display') isnt 'none'

        switch e.which
          when 8  # backspace
            unless @input.focused
              @remove()
              return no
            unless @input.val().length
              @next()
              return no
          when 13, 188  # enter ,
            if @input.focused
              @add(@input.val())
              return no
          when 37 # left
            unless @input.focused
              @prev()
              return no
            unless @input.val().length
              @next()
              return no
          when 39 # right
            unless @input.focused
              @next()
              return no


    # ok ----------------

    @add(@origin.val())
    @options.onReady.call(@)

  add: (tag) ->
    return unless tag

    if $.isArray(tag)
      $.each(tag, (i, v) => @add(v))
      return

    if tag.match(@separator)
      $.each(tag.split(@separator), (i, v) => @add(v))
      return

    tag = @_createTag(tag)

    unless @options.minLength < tag.length < @options.maxLength
      @options.onInvalid.call(@, tag)
      return

    if not @options.duplicates and (i=$.inArray(tag, @index)) > -1
      @options.onDuplicate.call(@, tag, i)
      return

    @index.push(tag)
    @input.parent().before(@_createTagElement(tag))
    @origin.val(@serialize())
    @input.val('')
    @options.onAdd.call(@, tag)

  remove: (element) ->

    if typeof element is 'string'
      return no unless (element=@find(element))

    if not element and (x=@selected()).length
      element = x.first()

    @next() unless @prev().length

    @_removeFromIndex(tag=element.find('.tag').text())
    element.remove()

    @origin.val(@serialize())
    @options.onRemove.call(@, tag, element)

  serialize: ->
    @index.join(@options.separator)

  focus: ->
    return @ if @focused

    $('.taginput-origin').not(@origin).each ->
      $(@).data('taginput')?.blur()

    @field.addClass('focus')
    @focused = yes

  blur: ->
    return @ unless @focused

    @field.removeClass('focus')
    @focused = no
    @deselect()
    @input.blur()

  selected: ->
    @field.find('.selected')

  select: (element) ->
    return element unless element.length

    if element.hasClass('new')
      @input.focus()
    else
      @input.blur()
      @deselect()
      @focus()
      element.addClass('selected')

    element

  deselect: ->
    @selected().removeClass('selected')

  prev: ->
    @select(
      if (x=@selected()).length
        x.prev(':not(.new)')
      else
        @field.find('li:not(.new):first')
    )

  next: ->
    @select(
      if (x=@selected()).length
         x.next()
       else
         @field.find('li:not(.new):last')
    )

  find: (tag) ->
    found = no
    @field.find('li:not(.new)').each(->
      if (x=$(@)).data('tag') is tag
        found = x
        return no
    )
    found

  _createTag: (tag) ->
    tag = tag.replace(@separator, '')
    tag = tag.toLowerCase() if @options.lowercase
    $.trim(tag)

  _createTagElement: (tag) ->
    el = $('<li>
              <span class="tag"></span>
              <i class="delete icon-remove-sign"></i>
            </li>').data('tag', tag)

    el.find('.tag').text(tag)

    el.find('.delete').on
      click: (e) =>
        @remove(el)

    el.on
      click: (e) =>
        @blur()
        @select(el)
        no

      focus: (e) =>
        @select(el)
        no

  _removeFromIndex: (tag) ->
    @index.splice(@index.indexOf(tag), 1)
