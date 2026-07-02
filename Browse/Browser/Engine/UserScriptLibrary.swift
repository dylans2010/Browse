import Foundation
import WebKit

final class UserScriptLibrary {
    static let shared = UserScriptLibrary()

    var audioActivityScript: WKUserScript {
        let source = """
        (function() {
            function checkAudio() {
                var playing = false;
                var media = document.querySelectorAll('video, audio');
                for (var i = 0; i < media.length; i++) {
                    if (!media[i].paused && !media[i].muted) {
                        playing = true;
                        break;
                    }
                }
                window.webkit.messageHandlers.audioActivityBridge.postMessage(playing);
            }

            document.addEventListener('play', checkAudio, true);
            document.addEventListener('pause', checkAudio, true);
            document.addEventListener('volumechange', checkAudio, true);

            setInterval(checkAudio, 2000);
        })();
        """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
    }
}
