// Terminal Loading Screen
window.addEventListener('load', function() {
    const loadingScreen = document.getElementById('loading-screen');
    setTimeout(() => {
        loadingScreen.style.opacity = '0';
        setTimeout(() => {
            loadingScreen.style.display = 'none';
        }, 500);
    }, 3000);
});

// Navigation Toggle
const navToggle = document.getElementById('navToggle');
const navList = document.getElementById('navList');

navToggle.addEventListener('click', function() {
    navList.classList.toggle('active');
    navToggle.classList.toggle('active');
    
    // Update aria attributes
    const isExpanded = navList.classList.contains('active');
    navToggle.setAttribute('aria-expanded', isExpanded);
});

// Close mobile menu when clicking on a link
document.querySelectorAll('.nav-list a').forEach(link => {
    link.addEventListener('click', () => {
        navList.classList.remove('active');
        navToggle.classList.remove('active');
        navToggle.setAttribute('aria-expanded', 'false');
    });
});

// Scroll Progress Bar
window.addEventListener('scroll', function() {
    const scrollProgress = document.getElementById('scroll-progress');
    const scrollTop = window.pageYOffset;
    const docHeight = document.body.offsetHeight - window.innerHeight;
    const scrollPercent = (scrollTop / docHeight) * 100;
    scrollProgress.style.width = scrollPercent + '%';
});

// Back to Top Button
const backToTopButton = document.getElementById('backToTop');

window.addEventListener('scroll', function() {
    if (window.pageYOffset > 300) {
        backToTopButton.classList.add('visible');
    } else {
        backToTopButton.classList.remove('visible');
    }
});

backToTopButton.addEventListener('click', function() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
});

// Smooth Scrolling for Navigation Links
function scrollToSection(sectionId) {
    const section = document.getElementById(sectionId);
    if (section) {
        section.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
    }
}

// Intersection Observer for Animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe all sections for animation
document.addEventListener('DOMContentLoaded', function() {
    const sections = document.querySelectorAll('section');
    sections.forEach(section => {
        section.style.opacity = '0';
        section.style.transform = 'translateY(30px)';
        section.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(section);
    });
});

// Terminal Typing Effect
function typeWriter(element, text, speed = 50) {
    let i = 0;
    element.textContent = '';
    
    function type() {
        if (i < text.length) {
            element.textContent += text.charAt(i);
            i++;
            setTimeout(type, speed);
        }
    }
    
    type();
}

// Initialize terminal typing effects
document.addEventListener('DOMContentLoaded', function() {
    const terminalLines = document.querySelectorAll('.terminal-line .command');
    let delay = 1000;
    
    terminalLines.forEach((line, index) => {
        const text = line.textContent;
        setTimeout(() => {
            typeWriter(line, text, 30);
        }, delay);
        delay += 800;
    });
});

// Add hover effects to cards
document.addEventListener('DOMContentLoaded', function() {
    const cards = document.querySelectorAll('.project-card, .analysis-card, .report-card, .contact-item, .metric-card');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
});

// Add keyboard navigation
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        navList.classList.remove('active');
        navToggle.classList.remove('active');
        navToggle.setAttribute('aria-expanded', 'false');
    }
});

// Add focus management for accessibility
document.addEventListener('DOMContentLoaded', function() {
    const focusableElements = document.querySelectorAll('a, button, input, textarea, select');
    
    focusableElements.forEach(element => {
        element.addEventListener('focus', function() {
            this.style.outline = '2px solid var(--primary)';
            this.style.outlineOffset = '2px';
        });
        
        element.addEventListener('blur', function() {
            this.style.outline = 'none';
        });
    });
});

// Performance optimization: Throttle scroll events
function throttle(func, limit) {
    let inThrottle;
    return function() {
        const args = arguments;
        const context = this;
        if (!inThrottle) {
            func.apply(context, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    }
}

// Apply throttling to scroll events
window.addEventListener('scroll', throttle(function() {
    // Scroll progress and back to top logic
    const scrollProgress = document.getElementById('scroll-progress');
    const scrollTop = window.pageYOffset;
    const docHeight = document.body.offsetHeight - window.innerHeight;
    const scrollPercent = (scrollTop / docHeight) * 100;
    scrollProgress.style.width = scrollPercent + '%';
    
    if (window.pageYOffset > 300) {
        backToTopButton.classList.add('visible');
    } else {
        backToTopButton.classList.remove('visible');
    }
}, 16)); // ~60fps

// Add loading animation for external links
document.addEventListener('DOMContentLoaded', function() {
    const externalLinks = document.querySelectorAll('a[target="_blank"]');
    
    externalLinks.forEach(link => {
        link.addEventListener('click', function() {
            this.style.opacity = '0.7';
            this.style.transform = 'scale(0.95)';
            
            setTimeout(() => {
                this.style.opacity = '1';
                this.style.transform = 'scale(1)';
            }, 200);
        });
    });
});

// Add error handling for images
document.addEventListener('DOMContentLoaded', function() {
    const images = document.querySelectorAll('img');
    
    images.forEach(img => {
        img.addEventListener('error', function() {
            this.style.display = 'none';
            console.warn('Failed to load image:', this.src);
        });
    });
});

// Terminal cursor blink effect
function addCursorBlink() {
    const cursor = document.querySelector('.terminal-line:last-child .command');
    if (cursor) {
        setInterval(() => {
            cursor.style.opacity = cursor.style.opacity === '0' ? '1' : '0';
        }, 500);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    setTimeout(addCursorBlink, 3000);
});

// Add service worker for PWA functionality (if supported)
if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('/sw.js')
            .then(function(registration) {
                console.log('SW registered: ', registration);
            })
            .catch(function(registrationError) {
                console.log('SW registration failed: ', registrationError);
            });
    });
}

// Add copy to clipboard functionality for code snippets
document.addEventListener('DOMContentLoaded', function() {
    const codeBlocks = document.querySelectorAll('code');
    
    codeBlocks.forEach(block => {
        block.addEventListener('click', function() {
            navigator.clipboard.writeText(this.textContent).then(() => {
                // Show feedback
                const originalText = this.textContent;
                this.textContent = 'Copied!';
                this.style.color = 'var(--success)';
                
                setTimeout(() => {
                    this.textContent = originalText;
                    this.style.color = '';
                }, 1000);
            });
        });
        
        block.style.cursor = 'pointer';
        block.title = 'Click to copy';
    });
});

// Add terminal-like focus effects
document.addEventListener('DOMContentLoaded', function() {
    const terminalElements = document.querySelectorAll('.terminal, .hero-terminal');
    
    terminalElements.forEach(terminal => {
        terminal.addEventListener('focus', function() {
            this.style.borderColor = 'var(--primary)';
            this.style.boxShadow = '0 0 20px rgba(0, 255, 0, 0.3)';
        });
        
        terminal.addEventListener('blur', function() {
            this.style.borderColor = 'var(--terminal-border)';
            this.style.boxShadow = 'var(--terminal-glow)';
        });
    });
});

// Ziad Hares Tech - Technical Portfolio JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Show terminal loading screen
    showTerminalLoading();
    
    // Update last updated timestamp
    updateLastUpdated();
    
    // Smooth scrolling for navigation links
    setupSmoothScrolling();
    
    // Add hover effects and animations
    setupAnimations();
    
    // Setup real-time updates
    setupRealTimeUpdates();
});

function showTerminalLoading() {
    const loadingScreen = document.getElementById('loading-screen');
    const commands = document.querySelectorAll('.command');
    
    // Type out commands one by one
    commands.forEach((command, index) => {
        setTimeout(() => {
            typeWriter(command, command.textContent, () => {
                if (index === commands.length - 1) {
                    // Last command typed, hide loading screen
                    setTimeout(() => {
                        loadingScreen.style.opacity = '0';
                        setTimeout(() => {
                            loadingScreen.style.display = 'none';
                        }, 500);
                    }, 1000);
                }
            });
        }, index * 1000);
    });
}

function typeWriter(element, text, callback) {
    element.textContent = '';
    let i = 0;
    
    function type() {
        if (i < text.length) {
            element.textContent += text.charAt(i);
            i++;
            setTimeout(type, 100);
        } else {
            if (callback) callback();
        }
    }
    
    type();
}

function updateLastUpdated() {
    const lastUpdatedElement = document.getElementById('last-updated');
    if (lastUpdatedElement) {
        const now = new Date();
        const options = {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        };
        lastUpdatedElement.textContent = now.toLocaleDateString('en-US', options);
    }
}

function setupSmoothScrolling() {
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                targetSection.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

function setupAnimations() {
    // Add intersection observer for fade-in animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observe all sections
    const sections = document.querySelectorAll('.section');
    sections.forEach(section => {
        section.style.opacity = '0';
        section.style.transform = 'translateY(20px)';
        section.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
        observer.observe(section);
    });
    
    // Add hover effects to project cards
    const projectCards = document.querySelectorAll('.project-card, .project-item, .report-item, .metric-card');
    projectCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
    
    // Add terminal cursor effect to status items
    const statusItems = document.querySelectorAll('.status-item');
    statusItems.forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.innerHTML += '<span class="terminal-cursor"></span>';
        });
        
        item.addEventListener('mouseleave', function() {
            const cursor = this.querySelector('.terminal-cursor');
            if (cursor) cursor.remove();
        });
    });
}

function setupRealTimeUpdates() {
    // Simulate real-time metric updates
    setInterval(() => {
        updateMetrics();
    }, 30000); // Update every 30 seconds
    
    // Add typing effect to status items
    const statusItems = document.querySelectorAll('.status-item');
    statusItems.forEach(item => {
        addTypingEffect(item);
    });
}

function updateMetrics() {
    // Simulate real-time metric updates
    const metricValues = document.querySelectorAll('.metric-value-large');
    metricValues.forEach(metric => {
        const currentValue = parseFloat(metric.textContent);
        const variation = (Math.random() - 0.5) * 2; // ±1 variation
        const newValue = Math.max(0, Math.min(100, currentValue + variation));
        metric.textContent = newValue.toFixed(2) + '/100';
        
        // Add flash effect
        metric.style.color = '#ffff00';
        setTimeout(() => {
            metric.style.color = '#00ff00';
        }, 200);
    });
}

function addTypingEffect(element) {
    const originalText = element.textContent;
    element.textContent = '';
    let i = 0;
    
    function typeWriter() {
        if (i < originalText.length) {
            element.textContent += originalText.charAt(i);
            i++;
            setTimeout(typeWriter, 100);
        }
    }
    
    // Start typing effect after a delay
    setTimeout(typeWriter, 1000);
}

// Add keyboard navigation
document.addEventListener('keydown', function(e) {
    switch(e.key) {
        case 'ArrowDown':
            e.preventDefault();
            scrollToNextSection();
            break;
        case 'ArrowUp':
            e.preventDefault();
            scrollToPreviousSection();
            break;
        case 'Home':
            e.preventDefault();
            window.scrollTo({ top: 0, behavior: 'smooth' });
            break;
        case 'End':
            e.preventDefault();
            window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
            break;
        case 'Escape':
            e.preventDefault();
            // Hide any open modals or return to top
            window.scrollTo({ top: 0, behavior: 'smooth' });
            break;
    }
});

function scrollToNextSection() {
    const sections = document.querySelectorAll('.section');
    const currentScroll = window.pageYOffset;
    
    for (let section of sections) {
        const sectionTop = section.offsetTop;
        if (sectionTop > currentScroll + 100) {
            section.scrollIntoView({ behavior: 'smooth' });
            break;
        }
    }
}

function scrollToPreviousSection() {
    const sections = Array.from(document.querySelectorAll('.section')).reverse();
    const currentScroll = window.pageYOffset;
    
    for (let section of sections) {
        const sectionTop = section.offsetTop;
        if (sectionTop < currentScroll - 100) {
            section.scrollIntoView({ behavior: 'smooth' });
            break;
        }
    }
}

// Add performance monitoring
function logPerformance() {
    if ('performance' in window) {
        const perfData = performance.getEntriesByType('navigation')[0];
        console.log('Page Load Time:', perfData.loadEventEnd - perfData.loadEventStart, 'ms');
        console.log('DOM Content Loaded:', perfData.domContentLoadedEventEnd - perfData.domContentLoadedEventStart, 'ms');
    }
}

// Log performance when page is fully loaded
window.addEventListener('load', logPerformance);

// Add error handling
window.addEventListener('error', function(e) {
    console.error('Portfolio Error:', e.error);
});

// Add console welcome message
console.log(`
%cZiad Hares Tech - Technical Portfolio
%c
%cWelcome to the advanced technical portfolio analysis system.
%cAll data is generated through comprehensive automated analysis scripts.
%c
%cFor technical inquiries: ziadhares.tech
%c
`, 
'color: #00ff00; font-size: 20px; font-weight: bold; font-family: monospace;',
'color: #888; font-size: 12px; font-family: monospace;',
'color: #00ff00; font-size: 14px; font-family: monospace;',
'color: #00ff00; font-size: 14px; font-family: monospace;',
'color: #00ff00; font-size: 14px; font-family: monospace;',
'color: #888; font-size: 12px; font-family: monospace;',
'color: #ffff00; font-size: 14px; font-weight: bold; font-family: monospace;'
);

// Matrix Background Effect
function createMatrixBackground() {
    const matrixBg = document.getElementById('matrix-bg');
    if (!matrixBg) return;
    
    const chars = '01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン';
    const columns = Math.floor(window.innerWidth / 20);
    const rows = Math.floor(window.innerHeight / 20);
    
    for (let i = 0; i < columns * rows; i++) {
        const char = document.createElement('div');
        char.className = 'matrix-char';
        char.textContent = chars[Math.floor(Math.random() * chars.length)];
        char.style.left = (i % columns) * 20 + 'px';
        char.style.animationDelay = Math.random() * 3 + 's';
        char.style.animationDuration = (Math.random() * 2 + 2) + 's';
        matrixBg.appendChild(char);
    }
}

// Enhanced Terminal Loading
function enhanceTerminalLoading() {
    const loadingScreen = document.getElementById('loading-screen');
    const terminalContent = loadingScreen.querySelector('.terminal-content');
    
    // Add typing effect to commands
    const commands = terminalContent.querySelectorAll('.command');
    commands.forEach((cmd, index) => {
        const text = cmd.textContent;
        cmd.textContent = '';
        cmd.style.opacity = '0';
        
        setTimeout(() => {
            cmd.style.opacity = '1';
            let i = 0;
            const typeWriter = () => {
                if (i < text.length) {
                    cmd.textContent += text.charAt(i);
                    i++;
                    setTimeout(typeWriter, 50);
                }
            };
            typeWriter();
        }, index * 1000);
    });
    
    // Add blinking cursor effect
    const cursor = terminalContent.querySelector('.cursor');
    if (cursor) {
        cursor.style.animation = 'blink 1s infinite';
    }
}

// Initialize enhanced features
document.addEventListener('DOMContentLoaded', function() {
    createMatrixBackground();
    enhanceTerminalLoading();
    
    // Hide loading screen after 4 seconds
    setTimeout(() => {
        const loadingScreen = document.getElementById('loading-screen');
        if (loadingScreen) {
            loadingScreen.style.opacity = '0';
            setTimeout(() => {
                loadingScreen.style.display = 'none';
            }, 500);
        }
    }, 4000);
}); 