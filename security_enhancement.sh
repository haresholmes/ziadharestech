#!/bin/bash

# Ziad Hares Tech - Security Enhancement Script
# Comprehensive security analysis and recommendations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Create security enhancement directory
mkdir -p security_recommendations
mkdir -p security_configs

echo -e "${CYAN}=== Ziad Hares Tech - Security Enhancement Suite ===${NC}"
echo -e "${YELLOW}Analyzing security posture and generating recommendations...${NC}"
echo

# Function to analyze project security
analyze_project_security() {
    local project_name=$1
    local project_url=$2
    local report_file="security_recommendations/${project_name}_security_enhancement.txt"
    local config_file="security_configs/${project_name}_security_config.txt"
    
    echo -e "${BLUE}Security Analysis: ${project_name}${NC}"
    echo "==========================================" > "$report_file"
    echo "SECURITY ENHANCEMENT REPORT" >> "$report_file"
    echo "Project: $project_name" >> "$report_file"
    echo "URL: $project_url" >> "$report_file"
    echo "Analysis Date: $(date)" >> "$report_file"
    echo "==========================================" >> "$report_file"
    echo >> "$report_file"
    
    # Get current headers
    echo -e "${YELLOW}  Analyzing current security headers...${NC}"
    local headers=$(curl -s -I "$project_url" 2>/dev/null || echo "")
    
    echo "CURRENT SECURITY STATUS:" >> "$report_file"
    echo "=========================" >> "$report_file"
    
    # Check each security header
    local security_headers=(
        "Strict-Transport-Security:HSTS:max-age=31536000; includeSubDomains; preload"
        "X-Frame-Options:X-Frame-Options:SAMEORIGIN"
        "X-Content-Type-Options:X-Content-Type-Options:nosniff"
        "X-XSS-Protection:X-XSS-Protection:1; mode=block"
        "Content-Security-Policy:CSP:default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https:; connect-src 'self' https:; frame-ancestors 'none';"
        "Referrer-Policy:Referrer-Policy:strict-origin-when-cross-origin"
        "Permissions-Policy:Permissions-Policy:geolocation=(), microphone=(), camera=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()"
        "X-Permitted-Cross-Domain-Policies:X-Permitted-Cross-Domain-Policies:none"
    )
    
    local missing_headers=()
    local present_headers=()
    
    for header in "${security_headers[@]}"; do
        local header_name=$(echo "$header" | cut -d: -f1)
        local header_short=$(echo "$header" | cut -d: -f2)
        local recommended_value=$(echo "$header" | cut -d: -f3)
        
        if echo "$headers" | grep -i "$header_name" > /dev/null; then
            local current_value=$(echo "$headers" | grep -i "$header_name" | head -1)
            echo "  ✓ $header_short: Present" >> "$report_file"
            echo "    Current: $current_value" >> "$report_file"
            echo "    Recommended: $header_name: $recommended_value" >> "$report_file"
            present_headers+=("$header_short")
            echo -e "${GREEN}    ✓ $header_short${NC}"
        else
            echo "  ✗ $header_short: Missing" >> "$report_file"
            echo "    Recommended: $header_name: $recommended_value" >> "$report_file"
            missing_headers+=("$header_short")
            echo -e "${RED}    ✗ $header_short${NC}"
        fi
        echo >> "$report_file"
    done
    
    # SSL/TLS Analysis
    echo -e "${YELLOW}  Analyzing SSL/TLS configuration...${NC}"
    echo "SSL/TLS ANALYSIS:" >> "$report_file"
    echo "=================" >> "$report_file"
    
    if echo "$project_url" | grep -q "https"; then
        local domain=$(echo "$project_url" | sed 's|https://||' | sed 's|/.*||')
        local ssl_info=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -text 2>/dev/null || echo "SSL check failed")
        
        echo "SSL Certificate Information:" >> "$report_file"
        echo "$ssl_info" >> "$report_file"
        echo -e "${GREEN}  ✓ SSL/TLS enabled${NC}"
    else
        echo "SSL/TLS: Not enabled (HTTP only)" >> "$report_file"
        echo -e "${RED}  ✗ SSL/TLS not enabled${NC}"
    fi
    
    # Generate security score
    local total_headers=8
    local present_count=${#present_headers[@]}
    local security_score=$((present_count * 100 / total_headers))
    
    echo "SECURITY SCORE: $security_score/100" >> "$report_file"
    echo "Present Headers: ${present_count}/${total_headers}" >> "$report_file"
    echo "Missing Headers: $((total_headers - present_count))/${total_headers}" >> "$report_file"
    echo >> "$report_file"
    
    # Generate recommendations
    echo "SECURITY RECOMMENDATIONS:" >> "$report_file"
    echo "========================" >> "$report_file"
    
    if [ ${#missing_headers[@]} -eq 0 ]; then
        echo "  ✓ All security headers are properly configured!" >> "$report_file"
        echo "  Recommendations:" >> "$report_file"
        echo "    - Monitor security headers regularly" >> "$report_file"
        echo "    - Consider implementing additional security measures" >> "$report_file"
        echo "    - Regular security audits recommended" >> "$report_file"
    else
        echo "  Missing security headers that should be implemented:" >> "$report_file"
        for header in "${missing_headers[@]}"; do
            echo "    - $header" >> "$report_file"
        done
        echo >> "$report_file"
        echo "  Implementation Priority:" >> "$report_file"
        echo "    1. HSTS (Critical for HTTPS sites)" >> "$report_file"
        echo "    2. CSP (Content Security Policy)" >> "$report_file"
        echo "    3. X-Frame-Options (Clickjacking protection)" >> "$report_file"
        echo "    4. X-Content-Type-Options (MIME sniffing protection)" >> "$report_file"
        echo "    5. X-XSS-Protection (XSS protection)" >> "$report_file"
        echo "    6. Referrer-Policy (Privacy protection)" >> "$report_file"
        echo "    7. Permissions-Policy (Feature policy)" >> "$report_file"
        echo "    8. X-Permitted-Cross-Domain-Policies (Flash protection)" >> "$report_file"
    fi
    
    # Generate configuration files
    generate_security_config "$project_name" "$project_url" "$config_file" "$missing_headers"
    
    echo >> "$report_file"
    echo "Analysis completed at: $(date)" >> "$report_file"
    echo "==========================================" >> "$report_file"
    
    echo -e "${GREEN}✓ Security analysis complete for $project_name${NC}"
    echo
}

# Function to generate security configuration
generate_security_config() {
    local project_name=$1
    local project_url=$2
    local config_file=$3
    local missing_headers=("${@:4}")
    
    echo "SECURITY CONFIGURATION FOR $project_name" > "$config_file"
    echo "Generated: $(date)" >> "$config_file"
    echo "==========================================" >> "$config_file"
    echo >> "$config_file"
    
    echo "RECOMMENDED SECURITY HEADERS:" >> "$config_file"
    echo "=============================" >> "$config_file"
    echo >> "$config_file"
    
    # Apache configuration
    echo "APACHE (.htaccess):" >> "$config_file"
    echo "-------------------" >> "$config_file"
    echo "Header always set Strict-Transport-Security \"max-age=31536000; includeSubDomains; preload\"" >> "$config_file"
    echo "Header always set X-Frame-Options \"SAMEORIGIN\"" >> "$config_file"
    echo "Header always set X-Content-Type-Options \"nosniff\"" >> "$config_file"
    echo "Header always set X-XSS-Protection \"1; mode=block\"" >> "$config_file"
    echo "Header always set Content-Security-Policy \"default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https:; connect-src 'self' https:; frame-ancestors 'none';\"" >> "$config_file"
    echo "Header always set Referrer-Policy \"strict-origin-when-cross-origin\"" >> "$config_file"
    echo "Header always set Permissions-Policy \"geolocation=(), microphone=(), camera=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()\"" >> "$config_file"
    echo "Header always set X-Permitted-Cross-Domain-Policies \"none\"" >> "$config_file"
    echo >> "$config_file"
    
    # Nginx configuration
    echo "NGINX (nginx.conf):" >> "$config_file"
    echo "-------------------" >> "$config_file"
    echo "add_header Strict-Transport-Security \"max-age=31536000; includeSubDomains; preload\" always;" >> "$config_file"
    echo "add_header X-Frame-Options \"SAMEORIGIN\" always;" >> "$config_file"
    echo "add_header X-Content-Type-Options \"nosniff\" always;" >> "$config_file"
    echo "add_header X-XSS-Protection \"1; mode=block\" always;" >> "$config_file"
    echo "add_header Content-Security-Policy \"default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https:; connect-src 'self' https:; frame-ancestors 'none';\" always;" >> "$config_file"
    echo "add_header Referrer-Policy \"strict-origin-when-cross-origin\" always;" >> "$config_file"
    echo "add_header Permissions-Policy \"geolocation=(), microphone=(), camera=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()\" always;" >> "$config_file"
    echo "add_header X-Permitted-Cross-Domain-Policies \"none\" always;" >> "$config_file"
    echo >> "$config_file"
    
    # Node.js/Express configuration
    echo "NODE.JS/EXPRESS (app.js):" >> "$config_file"
    echo "-------------------------" >> "$config_file"
    echo "const helmet = require('helmet');" >> "$config_file"
    echo "app.use(helmet());" >> "$config_file"
    echo "app.use(helmet.hidePoweredBy());" >> "$config_file"
    echo "app.use(helmet.frameguard({ action: 'sameorigin' }));" >> "$config_file"
    echo "app.use(helmet.xssFilter());" >> "$config_file"
    echo "app.use(helmet.noSniff());" >> "$config_file"
    echo "app.use(helmet.referrerPolicy({ policy: 'strict-origin-when-cross-origin' }));" >> "$config_file"
    echo "app.use(helmet.contentSecurityPolicy({" >> "$config_file"
    echo "  directives: {" >> "$config_file"
    echo "    defaultSrc: [\"'self'\"]," >> "$config_file"
    echo "    scriptSrc: [\"'self'\", \"'unsafe-inline'\", \"'unsafe-eval'\"]," >> "$config_file"
    echo "    styleSrc: [\"'self'\", \"'unsafe-inline'\"]," >> "$config_file"
    echo "    imgSrc: [\"'self'\", \"data:\", \"https:\"]," >> "$config_file"
    echo "    fontSrc: [\"'self'\", \"https:\"]," >> "$config_file"
    echo "    connectSrc: [\"'self'\", \"https:\"]," >> "$config_file"
    echo "    frameAncestors: [\"'none'\"]" >> "$config_file"
    echo "  }" >> "$config_file"
    echo "}));" >> "$config_file"
    echo >> "$config_file"
    
    # PHP configuration
    echo "PHP (security.php):" >> "$config_file"
    echo "-------------------" >> "$config_file"
    echo "<?php" >> "$config_file"
    echo "header('Strict-Transport-Security: max-age=31536000; includeSubDomains; preload');" >> "$config_file"
    echo "header('X-Frame-Options: SAMEORIGIN');" >> "$config_file"
    echo "header('X-Content-Type-Options: nosniff');" >> "$config_file"
    echo "header('X-XSS-Protection: 1; mode=block');" >> "$config_file"
    echo "header(\"Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https:; connect-src 'self' https:; frame-ancestors 'none';\");" >> "$config_file"
    echo "header('Referrer-Policy: strict-origin-when-cross-origin');" >> "$config_file"
    echo "header('Permissions-Policy: geolocation=(), microphone=(), camera=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()');" >> "$config_file"
    echo "header('X-Permitted-Cross-Domain-Policies: none');" >> "$config_file"
    echo "?>" >> "$config_file"
    echo >> "$config_file"
    
    # HTML meta tags (for static sites)
    echo "HTML META TAGS (index.html):" >> "$config_file"
    echo "----------------------------" >> "$config_file"
    echo "<meta http-equiv=\"Content-Security-Policy\" content=\"default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' https:; connect-src 'self' https:; frame-ancestors 'none';\">" >> "$config_file"
    echo "<meta http-equiv=\"X-Frame-Options\" content=\"SAMEORIGIN\">" >> "$config_file"
    echo "<meta http-equiv=\"X-Content-Type-Options\" content=\"nosniff\">" >> "$config_file"
    echo "<meta http-equiv=\"X-XSS-Protection\" content=\"1; mode=block\">" >> "$config_file"
    echo "<meta http-equiv=\"Referrer-Policy\" content=\"strict-origin-when-cross-origin\">" >> "$config_file"
    echo "<meta http-equiv=\"Permissions-Policy\" content=\"geolocation=(), microphone=(), camera=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()\">" >> "$config_file"
    echo "<meta http-equiv=\"X-Permitted-Cross-Domain-Policies\" content=\"none\">" >> "$config_file"
    echo >> "$config_file"
    
    echo "IMPLEMENTATION NOTES:" >> "$config_file"
    echo "====================" >> "$config_file"
    echo "- Choose the appropriate configuration based on your server setup" >> "$config_file"
    echo "- Test in staging environment before deploying to production" >> "$config_file"
    echo "- Monitor for any functionality issues after implementation" >> "$config_file"
    echo "- Consider using security testing tools to verify implementation" >> "$config_file"
    echo "- Regular security audits recommended" >> "$config_file"
}

# Function to generate comprehensive security summary
generate_security_summary() {
    local summary_file="security_recommendations/security_summary.txt"
    
    echo -e "${CYAN}Generating comprehensive security summary...${NC}"
    
    echo "ZIAD HARES TECH - SECURITY ENHANCEMENT SUMMARY" > "$summary_file"
    echo "Generated: $(date)" >> "$summary_file"
    echo "==========================================" >> "$summary_file"
    echo >> "$summary_file"
    
    echo "OVERALL SECURITY ASSESSMENT:" >> "$summary_file"
    echo "============================" >> "$summary_file"
    echo "  Total Projects Analyzed: 4" >> "$summary_file"
    echo "  Security Focus: High Priority" >> "$summary_file"
    echo "  Implementation Status: Requires Enhancement" >> "$summary_file"
    echo >> "$summary_file"
    
    echo "CRITICAL SECURITY HEADERS:" >> "$summary_file"
    echo "=========================" >> "$summary_file"
    echo "  1. HSTS (HTTP Strict Transport Security)" >> "$summary_file"
    echo "     - Purpose: Force HTTPS connections" >> "$summary_file"
    echo "     - Priority: Critical" >> "$summary_file"
    echo "     - Implementation: Server configuration" >> "$summary_file"
    echo >> "$summary_file"
    echo "  2. CSP (Content Security Policy)" >> "$summary_file"
    echo "     - Purpose: Prevent XSS and injection attacks" >> "$summary_file"
    echo "     - Priority: Critical" >> "$summary_file"
    echo "     - Implementation: Server configuration or meta tags" >> "$summary_file"
    echo >> "$summary_file"
    echo "  3. X-Frame-Options" >> "$summary_file"
    echo "     - Purpose: Prevent clickjacking attacks" >> "$summary_file"
    echo "     - Priority: High" >> "$summary_file"
    echo "     - Implementation: Server configuration" >> "$summary_file"
    echo >> "$summary_file"
    echo "  4. X-Content-Type-Options" >> "$summary_file"
    echo "     - Purpose: Prevent MIME type sniffing" >> "$summary_file"
    echo "     - Priority: High" >> "$summary_file"
    echo "     - Implementation: Server configuration" >> "$summary_file"
    echo >> "$summary_file"
    echo "  5. X-XSS-Protection" >> "$summary_file"
    echo "     - Purpose: Additional XSS protection" >> "$summary_file"
    echo "     - Priority: Medium" >> "$summary_file"
    echo "     - Implementation: Server configuration" >> "$summary_file"
    echo >> "$summary_file"
    echo "  6. Referrer-Policy" >> "$summary_file"
    echo "     - Purpose: Control referrer information" >> "$summary_file"
    echo "     - Priority: Medium" >> "$summary_file"
    echo "     - Implementation: Server configuration" >> "$summary_file"
    echo >> "$summary_file"
    echo "  7. Permissions-Policy" >> "$summary_file"
    echo "     - Purpose: Control browser features" >> "$summary_file"
    echo "     - Priority: Medium" >> "$summary_file"
    echo "     - Implementation: Server configuration" >> "$summary_file"
    echo >> "$summary_file"
    echo "  8. X-Permitted-Cross-Domain-Policies" >> "$summary_file"
    echo "     - Purpose: Control cross-domain policies" >> "$summary_file"
    echo "     - Priority: Low" >> "$summary_file"
    echo "     - Implementation: Server configuration" >> "$summary_file"
    echo >> "$summary_file"
    
    echo "IMPLEMENTATION ROADMAP:" >> "$summary_file"
    echo "======================" >> "$summary_file"
    echo "  Phase 1 (Immediate):" >> "$summary_file"
    echo "    - Implement HSTS for all HTTPS sites" >> "$summary_file"
    echo "    - Add X-Frame-Options header" >> "$summary_file"
    echo "    - Add X-Content-Type-Options header" >> "$summary_file"
    echo >> "$summary_file"
    echo "  Phase 2 (Short-term):" >> "$summary_file"
    echo "    - Implement Content Security Policy" >> "$summary_file"
    echo "    - Add X-XSS-Protection header" >> "$summary_file"
    echo "    - Add Referrer-Policy header" >> "$summary_file"
    echo >> "$summary_file"
    echo "  Phase 3 (Medium-term):" >> "$summary_file"
    echo "    - Implement Permissions-Policy" >> "$summary_file"
    echo "    - Add X-Permitted-Cross-Domain-Policies" >> "$summary_file"
    echo "    - Security testing and validation" >> "$summary_file"
    echo >> "$summary_file"
    
    echo "SECURITY TESTING TOOLS:" >> "$summary_file"
    echo "======================" >> "$summary_file"
    echo "  - Mozilla Observatory: https://observatory.mozilla.org/" >> "$summary_file"
    echo "  - Security Headers: https://securityheaders.com/" >> "$summary_file"
    echo "  - SSL Labs: https://www.ssllabs.com/ssltest/" >> "$summary_file"
    echo "  - OWASP ZAP: https://owasp.org/www-project-zap/" >> "$summary_file"
    echo >> "$summary_file"
    
    echo "MONITORING AND MAINTENANCE:" >> "$summary_file"
    echo "===========================" >> "$summary_file"
    echo "  - Regular security header audits" >> "$summary_file"
    echo "  - Monitor for security vulnerabilities" >> "$summary_file"
    echo "  - Keep security configurations updated" >> "$summary_file"
    echo "  - Test security measures regularly" >> "$summary_file"
    echo "  - Document security policies and procedures" >> "$summary_file"
    echo >> "$summary_file"
    
    echo "==========================================" >> "$summary_file"
    echo "End of Security Enhancement Summary" >> "$summary_file"
    
    echo -e "${GREEN}✓ Security summary generated${NC}"
}

# Main security analysis execution
echo -e "${PURPLE}Starting comprehensive security analysis...${NC}"
echo

# Analyze each project's security
analyze_project_security "amalak" "https://amalak.ae"
analyze_project_security "bettercallramadan" "https://bettercallramadan.com"
analyze_project_security "haresholmes" "https://haresholmes.eu.org"
analyze_project_security "thepiratesdxb" "https://thepiratesdxb.software"

# Generate comprehensive security summary
generate_security_summary

echo -e "${CYAN}=== Security Enhancement Analysis Complete ===${NC}"
echo -e "${GREEN}✓ All projects analyzed for security enhancements${NC}"
echo -e "${GREEN}✓ Security recommendations saved to security_recommendations/${NC}"
echo -e "${GREEN}✓ Configuration files saved to security_configs/${NC}"
echo
echo -e "${YELLOW}Security files available:${NC}"
echo -e "${YELLOW}  - security_recommendations/*_security_enhancement.txt${NC}"
echo -e "${YELLOW}  - security_configs/*_security_config.txt${NC}"
echo -e "${YELLOW}  - security_recommendations/security_summary.txt${NC}"
echo
echo -e "${CYAN}Next Steps:${NC}"
echo -e "${CYAN}  1. Review security recommendations for each project${NC}"
echo -e "${CYAN}  2. Choose appropriate configuration based on server setup${NC}"
echo -e "${CYAN}  3. Implement security headers in staging environment first${NC}"
echo -e "${CYAN}  4. Test thoroughly before deploying to production${NC}"
echo -e "${CYAN}  5. Monitor for any functionality issues${NC}" 