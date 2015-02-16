class SpreadImageView < NSView
  def initWithFrame(frame)
    super

    @leftImageView = NSImageView.alloc.initWithFrame(NSMakeRect(0, 0, 0, 0))
    @leftImageView.imageAlignment = NSImageAlignRight
    @leftImageView.imageScaling = NSImageScaleProportionallyUpOrDown
    addSubview(@leftImageView)

    @rightImageView = NSImageView.alloc.initWithFrame(NSMakeRect(0, 0, 0, 0))
    @rightImageView.imageAlignment = NSImageAlignLeft
    @rightImageView.imageScaling = NSImageScaleProportionallyUpOrDown
    addSubview(@rightImageView)

    setImageViewsSize

    self
  end

  def isOpaque
    true
  end

  def drawRect(rect)
    NSColor.blackColor.set
    NSRectFill(rect)
  end

  def resizeSubviewsWithOldSize(oldSize)
    setImageViewsSize
  end

  def setPages(pages)
    right, left = *pages

    @leftImageView.image = left ? left.image : nil
    @rightImageView.image = right ? right.image : nil
  end

  private

  def setImageViewsSize
    width = bounds.size.width
    halfWidth = width / 2
    height = bounds.size.height

    @leftImageView.setFrameOrigin(NSMakeSize(0, 0))
    @leftImageView.setFrameSize(NSMakeSize(halfWidth, height))

    @rightImageView.setFrameOrigin(NSMakeSize(halfWidth, 0))
    @rightImageView.setFrameSize(NSMakeSize(halfWidth, height))
  end
end
