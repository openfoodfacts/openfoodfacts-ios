require 'xcodeproj'
require 'versionomy'

def highest_app_version_number()
    puts "login into spaceship"
    Spaceship::Tunes.login()
    app = Spaceship::Tunes::Application.find(ENV['APP_BUNDLE_IDENTIFIER'])
    
    liveVersion = nil

    if app && app.live_version
        liveVersion = app.live_version.version
    end

    if app && app.edit_version && liveVersion.nil?
        editVersion = app.edit_version.version
        return liveVersion, editVersion
    else
        return liveVersion, nil
    end
ensure
    puts "Live Version: #{liveVersion}\tEdit Version: #{editVersion}"
end

def app_store_version_to_upload_to(projectVersion:)
    puts "fetching app_store_version_to_upload_to"

    liveVersion, editVersion = highest_app_version_number()
    projectVersionParsed = Versionomy.parse(projectVersion)

    unless editVersion.nil?
        puts "use edit version #{editVersion}"
        editVersionParsed = Versionomy.parse(editVersion)
        return editVersionParsed > projectVersionParsed ? editVersion : projectVersionParsed
    end
    if liveVersion.nil?
        puts "no live version, using #{projectVersion}"
        return projectVersion
    end

    liveVersionParsed = Versionomy.parse(liveVersion)
    bumped = liveVersionParsed.bump(:tiny)

    ourVersion = bumped > projectVersionParsed ? bumped.to_s : projectVersion

    puts "existing live version = #{liveVersion}, using version #{ourVersion}"
    return ourVersion
end