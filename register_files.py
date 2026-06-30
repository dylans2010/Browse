import uuid
import os
import re

def generate_id():
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

def register_file(file_path):
    pbx_path = 'Browse/Browse.xcodeproj/project.pbxproj'
    with open(pbx_path, 'r') as f:
        content = f.read()

    filename = os.path.basename(file_path)
    file_id = generate_id()
    build_id = generate_id()

    # Check if file already registered
    if filename in content:
        print(f"{filename} already registered.")
        return

    # Add to PBXBuildFile
    build_file_entry = f'\t\t{build_id} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {filename} */; }};'
    content = content.replace('/* BEGIN PBXBuildFile */', '/* BEGIN PBXBuildFile */\n' + build_file_entry)

    # Add to PBXFileReference
    # Find last Known file type
    file_type = "sourcecode.swift"
    if filename.endswith(".plist"): file_type = "text.plist.xml"

    file_ref_entry = f'\t\t{file_id} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = {file_type}; path = {file_path}; sourceTree = "<group>"; }};'
    content = content.replace('/* BEGIN PBXFileReference */', '/* BEGIN PBXFileReference */\n' + file_ref_entry)

    # Add to PBXGroup (I'll just add to the main Browse group 3BB7A8AF for now to keep it simple)
    # Actually, let's find the Browse group children
    pattern = r'(3BB7A8AF /\* Browse \*/ = {.*?children = \()(.*?)(\);)'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        children = match.group(2)
        new_children = f'\n\t\t\t\t{file_id} /* {filename} */,' + children
        content = content[:match.start(2)] + new_children + content[match.end(2):]

    # Add to PBXSourcesBuildPhase
    content = content.replace('/* BEGIN PBXSourcesBuildPhase */', '/* BEGIN PBXSourcesBuildPhase */\n')
    pattern = r'(isa = PBXSourcesBuildPhase;.*?files = \()(.*?)(\);)'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        files = match.group(2)
        new_files = f'\n\t\t\t\t{build_id} /* {filename} in Sources */,' + files
        content = content[:match.start(2)] + new_files + content[match.end(2):]

    with open(pbx_path, 'w') as f:
        f.write(content)
    print(f"Registered {filename} with ID {file_id}")

files_to_register = [
    'Core/Services/LoggingService.swift',
    'Core/Services/AnalyticsService.swift'
]

for f in files_to_register:
    register_file(f)
