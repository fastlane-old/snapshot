module Snapshot
  class Setup
    # This method will take care of creating a Snapfile and other necessary files
    def self.create(path)
      snapfile_path = File.join(path, 'Snapfile')

      if File.exist?(snapfile_path)
        raise "Snapfile already exists at path '#{snapfile_path}'. Run 'snapshot' to use snapshot.".red
      end

      gem_path = Helper.gem_path("snapshot")
      File.write(snapfile_path, File.read("#{gem_path}/lib/assets/SnapfileTemplate"))
      File.write(File.join(path, 'SnapshotHelper.swift'), File.read("#{gem_path}/lib/assets/SnapshotHelper.swift"))
      File.write(File.join(path, 'SnapshotAlertManager.swift'), File.read("#{gem_path}/lib/assets/SnapshotAlertManager.swift"))

      puts "Successfully created SnapshotHelper.swift '#{File.join(path, 'SnapshotHelper.swift')}'".green
      puts "Successfully created SnapshotAlertManager.swift '#{File.join(path, 'SnapshotAlertManager.swift')}'".green
      puts "Successfully created new Snapfile at '#{snapfile_path}'".green

      puts "-------------------------------------------------------".yellow
      puts "Open your Xcode project and make sure to do the following:".yellow
      puts "1) Add the ./SnapshotHelper.swift and ./SnapshotAlertManager.swift files to your UI Test target".yellow
      puts "   You can move the files anywhere you want".yellow
      puts "2) Call `setupSnapshot(app)` when launching your app".yellow
      puts ""
      puts "  let app = XCUIApplication()"
      puts "  setupSnapshot(app)"
      puts "  app.launch()"
      puts ""
      puts "3) Add `snapshot(\"0Launch\")` to wherever you want to create the screenshots".yellow
      puts ""
      puts "4) Optional : You can ask snapshot to automatically dismiss any alert that gets in the way of your actions/snapshots by calling automaticallyDismissAlerts(self) once in your test code".yellow
      puts "More information on GitHub: https://github.com/krausefx/snapshot".green
    end
  end
end
