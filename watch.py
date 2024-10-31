import os
import time
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

ignored_folders = ['build', '.vscode', '.git']

class FileWachter(FileSystemEventHandler):
    def on_modified(self, event):

        for folder in ignored_folders:
            if folder in event.src_path:
                return
            
        if event.src_path.endswith('.s'):
            if not event.src_path.endswith('compile.bat'):
                os.system('cls' if os.name == 'nt' else 'clear')
                print(f'File changed: {event.src_path}. Running compile.bat...')
                # Run the compile.bat script
                subprocess.run([script_path])
                # check in the subprocess if the errorlevel is 0

if __name__ == "__main__":
    folder = os.path.dirname(os.path.abspath(__file__))
    
    if os.name == 'nt':
        script_path = os.path.join(folder, "compile.bat")
    else:
        script_path = os.path.join(folder, "compile.sh")
    
    # Check if compile.bat exists
    if not os.path.isfile(script_path):
        print(f"Error: compile.bat not found in {folder}")
        exit(1)
    
    event_handler = FileWachter()
    observer = Observer()
    observer.schedule(event_handler, folder, recursive=True) 
    # Start the observer
    observer.start()
    print(f"Watching folder: {folder}")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
