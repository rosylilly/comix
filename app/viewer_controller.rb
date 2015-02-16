class ViewerController < NSWindowController
  MIN_WIDTH = 480
  MIN_HEIGHT = 360

  KEY_MAPPINGS = {
    'a' => :nextPage,
    'h' => :nextPage,
    'd' => :prevPage,
    'l' => :prevPage
  }

  def init
    super

    @comic = nil

    window.orderFrontRegardless
  end

  def window
    return @window if @window

    @window = NSWindow.alloc.initWithContentRect([[240, 180], [MIN_WIDTH, MIN_HEIGHT]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @window.delegate = self
    @window.makeFirstResponder(self)
    @window.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @window.setCollectionBehavior(NSWindowCollectionBehaviorFullScreenPrimary)
    @window.setMinSize(NSMakeSize(MIN_WIDTH, MIN_HEIGHT))

    @spreadImageView = SpreadImageView.alloc.initWithFrame(NSMakeRect(0, 0, MIN_WIDTH, MIN_HEIGHT))
    @spreadImageView.setAutoresizingMask(NSViewWidthSizable|NSViewHeightSizable)
    @window.contentView.addSubview(@spreadImageView)

    @window
  end

  def openDocument(sender)
    dialog = NSOpenPanel.openPanel
    dialog.canChooseFiles = true
    dialog.canChooseDirectories = false
    dialog.allowsMultipleSelection = false
    dialog.allowedFileTypes = Comic::ALLOWED_EXTS

    if dialog.runModal() == NSOKButton
      openComic(dialog.filenames.first)
    end
  end

  def openComic(path)
    @comic = Comic.new(path)
    applyPages
  end

  def acceptsFirstResponder
    true
  end

  def keyDown(event)
    action = KEY_MAPPINGS[event.characters]
    send(action) if action
  end

  def nextPage
    @comic.cursor += 1 if @comic.cursor < @comic.maxCursor
    applyPages
  end

  def prevPage
    @comic.cursor -= 1 if @comic.cursor > 0
    applyPages
  end

  def nextArchive
  end

  private

  def applyPages
    @spreadImageView.setPages(@comic.currentPages)
  end
end
