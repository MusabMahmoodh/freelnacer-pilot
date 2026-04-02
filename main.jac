"""Fullstack Starter - Entry Point.

Imports server-side symbols and mounts the client app.
"""

import from service.appService { greet }
import from services.pitchService { generate_pitch }

cl import from .index { ClientApp }

cl {
    def:pub app() -> JsxElement {
        return <ClientApp />;
    }
}
