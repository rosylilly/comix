class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu

    @viewer = ViewerController.alloc.init
  end
end
