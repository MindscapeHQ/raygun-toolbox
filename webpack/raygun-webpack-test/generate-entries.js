// generate-entries.js
const fs = require('fs');
const path = require('path');

const sourceDir = path.join(__dirname, 'src');

// Create src directory if it doesn't exist
if (!fs.existsSync(sourceDir)) {
    fs.mkdirSync(sourceDir);
}

// Generate 150 JS files
for (let i = 1; i <= 150; i++) {
    const jsContent = `// entry${i}.js

// Each file has unique content and calculations
const uniqueValue${i} = ${Math.random() * 1000};

export class Example${i} {
    constructor() {
        this.value = 'Example ${i}';
        this.uniqueId = uniqueValue${i};
    }

    calculate() {
        return Math.sin(this.uniqueId) * ${i};
    }

    doSomething() {
        console.log(this.value, this.calculate());
    }
}

const example = new Example${i}();
example.doSomething();
`;

    const cssContent = `
/* styles${i}.css */
.example-${i} {
    color: #${Math.floor(Math.random()*16777215).toString(16).padStart(6, '0')};
    padding: ${i % 20 + 10}px;
    margin: ${i % 15 + 5}px;
    border: ${i % 5 + 1}px solid #ccc;
    border-radius: ${i % 10 + 2}px;
}

.unique-${i} {
    background: linear-gradient(${i % 360}deg, #${Math.floor(Math.random()*16777215).toString(16).padStart(6, '0')}, #${Math.floor(Math.random()*16777215).toString(16).padStart(6, '0')});
    transform: rotate(${i}deg);
}
`;

    fs.writeFileSync(path.join(sourceDir, `entry${i}.js`), jsContent);
    fs.writeFileSync(path.join(sourceDir, `styles${i}.css`), cssContent);
}

console.log('Generated 150 entry points with CSS files');