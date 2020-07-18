require 'xcodeproj'
require 'versionomy'

def highest_app_version_number()
    puts "login into spaceship"

    token = Spaceship::ConnectAPI::Token.create
    Spaceship::ConnectAPI.token = token

    app = Spaceship::ConnectAPI.get_apps(filter: { bundleId: ENV['APP_BUNDLE_IDENTIFIER'] }).first
    
    liveAppStoreVersion = app.get_live_app_store_version()
    editAppStoreVersion = app.get_edit_app_store_version()

    liveVersion = nil

    if liveAppStoreVersion && liveAppStoreVersion.version_string
        liveVersion = liveAppStoreVersion.version_string
    end

    if editAppStoreVersion && editAppStoreVersion.version_string && liveVersion.nil?
        editVersion = editAppStoreVersion.version_string
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

def app_store_build_number_with_connect_api()
    puts "login into spaceship"

    token = Spaceship::ConnectAPI::Token.create
    Spaceship::ConnectAPI.token = token

    app = Spaceship::ConnectAPI.get_apps(filter: { bundleId: ENV['APP_BUNDLE_IDENTIFIER'] }).first

    return app.get_builds().first.version
end