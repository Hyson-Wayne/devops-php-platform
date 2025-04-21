<?php
// test.php - Basic sanity test
echo "Running PHP Test...\n";

require_once "index.php";

// Simulate a basic test condition
if (function_exists('phpinfo')) {
    echo "✅ PHP is working.\n";
    exit(0);
} else {
    echo "❌ Test failed: phpinfo() not available.\n";
    exit(1);
}