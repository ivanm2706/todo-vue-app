set -e

npm run build

cd dist

echo > .nojekyll

git init
git checkout -B main
git add -A 
git commit -m 'deploy'
git remote add origin https://github.com/ivanm2706/todo-vue-app.git
git push origin main:gh-pages

cd -