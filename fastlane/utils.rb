require 'xcodeproj'
require 'versionomy'

def highest_app_version_number()
    puts "login into spaceship"

    token = Spaceship::ConnectAPI::Token.create
    Spaceship::ConnectAPI.token = token

    app = Spaceship::ConnectAPI.get_apps(filter: { bundleId: ENV['APP_BUNDLE_IDENTIFIER'] }).first
    
    liveAppStoreVersion = app.get_live_app_store_version()
    editAppStoreVersion = app.get_edit_app_store_version()

    maxUploadedBuildVersion = app.get_builds(filter: nil, includes: "preReleaseVersion")
        .select { |v| !v.pre_release_version.nil? }  # builds without pre_release_version crash when accessing .app_version
        .sort_by { |v| Gem::Version.new(v.app_version) }
        .last
    
    liveVersion = nil
    editVersion = nil

    if liveAppStoreVersion && liveAppStoreVersion.version_string
        puts "considering version being live in app store connect: #{liveAppStoreVersion.version_string}"
        liveVersion = liveAppStoreVersion.version_string
    end

    if editAppStoreVersion && editAppStoreVersion.version_string
        puts "considering version being edited in app store connect: #{editAppStoreVersion.version_string}"
        editVersion = editAppStoreVersion.version_string
    end

    if maxUploadedBuildVersion && maxUploadedBuildVersion.pre_release_version
        puts "considering max version of uploaded builds: #{maxUploadedBuildVersion.app_version}"
        if(editVersion.nil? || Versionomy.parse(maxUploadedBuildVersion.app_version) > Versionomy.parse(editVersion))
            puts "prefering max version of uploaded builds: #{maxUploadedBuildVersion.app_version}"
            editVersion = maxUploadedBuildVersion.app_version        
        end
    end

    return liveVersion, editVersion
ensure
    puts "Live Version: #{liveVersion}\tEdit Version: #{editVersion}"
end

def version_to_use_from_git_branch(gitBranch:, projectVersion:)
    gitBranchVersion = gitBranch.split('release/')[1]
    gitBranchVersionParsed = Versionomy.parse(gitBranchVersion)
    projectVersionParsed = Versionomy.parse(projectVersion)

    ourVersion = gitBranchVersionParsed > projectVersionParsed ? gitBranchVersionParsed.to_s : projectVersion
    
    puts "Using #{ourVersion} by comparing gitBranch=#{gitBranchVersion} and project version=#{projectVersion}"
    
    return ourVersion
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