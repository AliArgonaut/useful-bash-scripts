
#!/usr/bin/env bash


show_help() {
    echo "VITA-MIX: create vite react apps with options"
    echo "Usage: vita-mix [options] <project-name>"
    echo ""
    echo "Options:"
    echo "  -t      Install Tailwind CSS"
    echo "  -s      Install shadcn/ui (requires Tailwind)"
    echo "  -r      Run the app after setup (npm run dev)"
    echo "  -h      Show this help menu"
    echo ""
    echo "Examples:"
    echo "  vita-mix myapp"
    echo "  vita-mix -t myapp"
    echo "  vita-mix -t -s -r myapp"
}

INSTALL_TAILWIND=false
INSTALL_SHADCN=false
RUN_APP=false

# Parse flags
while getopts "tsrh" opt; do
  case $opt in
    t) INSTALL_TAILWIND=true ;;
    s) INSTALL_SHADCN=true ;;
    r) RUN_APP=true ;;
    h) show_help; exit 0 ;;
    *) show_help; exit 1 ;;
  esac
done

shift $((OPTIND - 1))

PROJECT_NAME="$1"

if [ -z "$PROJECT_NAME" ]; then
    echo "Error: project name required."
    echo ""
    show_help
    exit 1
fi

echo "🔥 Creating Vite React app: $PROJECT_NAME"
npm create vite@latest "$PROJECT_NAME" -- --template react 

cd "$PROJECT_NAME"

echo "🧹 Cleaning template files..."
rm -f src/App.css
rm -f src/assets/react.svg
rm -f public/vite.svg

cat > src/App.jsx << 'EOF'
export default function App() {
  return <h1>Hello World</h1>;
}
EOF

echo "📦 Installing dependencies..."
npm install

# ------------------------
# Tailwind Install
# ------------------------
if [ "$INSTALL_TAILWIND" = true ]; then
  echo "🌬️ Installing Tailwind CSS..."
  
  npm install tailwindcss @tailwindcss/vite 

  cat > src/index.css <<'EOF'
@import "tailwindcss"
EOF

fi

npm install
# ------------------------
# shadcn/ui Install
# ------------------------
if [ "$INSTALL_SHADCN" = true ]; then
  if [ "$INSTALL_TAILWIND" = false ]; then
    echo "❌ Error: shadcn/ui requires Tailwind."
    echo "Use: create-vite-project -t -s myapp"
    exit 1
  fi

  echo "✨ Installing shadcn/ui..."

  # Install base dependencies
  npm install class-variance-authority clsx tailwind-merge lucide-react

  # Run shadcn init
  npx shadcn@latest init

  echo "📦 shadcn/ui installed. Add components using:"
  echo "  npx shadcn@latest add button"
fi

#CONFIGURING VITE CONFIG TO ACCEPT TAILWIND
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from "@tailwindcss/vite";
// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
})
EOF

npm install


# ------------------------
# Run dev server
# ------------------------
if [ "$RUN_APP" = true ]; then
  echo "🚀 Starting dev server..."
  npm run dev
fi

echo "✅ Done!"
