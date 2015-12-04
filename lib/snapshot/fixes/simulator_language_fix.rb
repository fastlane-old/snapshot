module Snapshot
  module Fixes
    class SimulatorLanguageFix
      def self.patch(language)
        # First we need to kill the simulator
        `killall iOS Simulator &> /dev/null`
  
        FastlaneCore::Simulator.all.each do |simulator|
          simulator_udid = simulator.udid

          sim_pref_path = sim_prefs(simulator_udid)
          sim_language = language.tr("-", "_") # plist takes unterscores
        
          Helper.log.debug "Patching simulator #{simulator.name} to language #{sim_language}"
        
          command = "defaults write '#{sim_pref_path}' 'AppleLocale' '#{sim_language}'"
          puts command.yellow if $debug
          `#{command}`
          
          command2 = "defaults write '#{sim_pref_path}' 'AppleLanguages' '(#{sim_language})'"
          puts command2.yellow if $debug
          `#{command2}`
        end
      end
  
      def self.sim_prefs(sim_udid)
        File.join(File.expand_path("~"), "Library", "Developer", "CoreSimulator", "Devices", sim_udid, "data", "Library", "Preferences", ".GlobalPreferences.plist")
      end
    end
  end
end  