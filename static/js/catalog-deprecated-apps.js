/**
 * Catalog Deprecated Apps Handler
 * Adds badges to deprecated apps on the catalog page
 */

(function() {
  'use strict';

  let deprecatedApps = {};

  // Calculate days until removal
  function daysUntilRemoval(removalDateStr) {
    try {
      const removal = new Date(removalDateStr);
      if (isNaN(removal.getTime())) {
        console.warn('Invalid date:', removalDateStr);
        return 999; // Treat as far future
      }
      const now = new Date();
      const diffTime = removal - now;
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
      return Math.max(0, diffDays); // Never negative
    } catch (error) {
      console.error('Date parsing error:', error);
      return 999;
    }
  }

  // Get the most urgent deprecation for an app (for badge display)
  function getMostUrgentDeprecation(deprecations) {
    let mostUrgent = null;
    let minDays = Infinity;

    deprecations.forEach(dep => {
      const days = daysUntilRemoval(dep.removal_date);
      if (days < minDays) {
        minDays = days;
        mostUrgent = {
          ...dep,
          daysRemaining: days
        };
      }
    });

    return mostUrgent;
  }

  // Load deprecated apps data
  async function loadDeprecatedApps() {
    try {
      const response = await fetch('/data/app-deprecations.yaml');
      const yamlText = await response.text();

      // Parse YAML structure
      const apps = {};
      const lines = yamlText.split('\n');
      let currentApp = null;
      let inDeprecations = false;
      let currentDeprecation = null;
      let inPartialDetails = false;

      for (const line of lines) {
        // Skip empty lines and comments
        if (line.trim() === '' || line.trim().startsWith('#')) {
          continue;
        }

        // Match app names (no leading whitespace, ends with colon)
        const appMatch = line.match(/^([a-z0-9_-]+):/);
        if (appMatch) {
          currentApp = appMatch[1];
          apps[currentApp] = {
            name: currentApp,
            deprecations: []
          };
          inDeprecations = false;
          inPartialDetails = false;
          continue;
        }

        if (!currentApp) continue;

        // Match train
        const trainMatch = line.match(/^\s+train:\s*(.+)/);
        if (trainMatch) {
          apps[currentApp].train = trainMatch[1];
          continue;
        }

        // Match title
        const titleMatch = line.match(/^\s+title:\s*"(.+)"/);
        if (titleMatch) {
          apps[currentApp].title = titleMatch[1];
          continue;
        }

        // Match deprecations array start
        if (line.match(/^\s+deprecations:/)) {
          inDeprecations = true;
          continue;
        }

        // Match deprecation entry (list item with scope)
        if (inDeprecations) {
          const scopeMatch = line.match(/^\s+-\s+scope:\s*(.+)/);
          if (scopeMatch) {
            // Remove surrounding quotes if present
            const scope = scopeMatch[1].replace(/^["']|["']$/g, '').trim();
            currentDeprecation = {
              scope: scope
            };
            apps[currentApp].deprecations.push(currentDeprecation);
            inPartialDetails = false;
            continue;
          }

          // Match deprecation fields
          if (currentDeprecation) {
            const dateMatch = line.match(/^\s+(deprecated_date|removal_date):\s*"(.+)"/);
            if (dateMatch) {
              currentDeprecation[dateMatch[1]] = dateMatch[2];
              continue;
            }

            const reasonMatch = line.match(/^\s+reason:\s*"(.+)"/);
            if (reasonMatch) {
              currentDeprecation.reason = reasonMatch[1];
              continue;
            }

            // Match partial_details start
            if (line.match(/^\s+partial_details:/)) {
              inPartialDetails = true;
              currentDeprecation.partial_details = {};
              continue;
            }

            // Match partial_details fields
            if (inPartialDetails) {
              const featureMatch = line.match(/^\s+feature:\s*"(.+)"/);
              if (featureMatch) {
                currentDeprecation.partial_details.feature = featureMatch[1];
                continue;
              }

              const descMatch = line.match(/^\s+description:\s*"(.+)"/);
              if (descMatch) {
                currentDeprecation.partial_details.description = descMatch[1];
                continue;
              }
            }
          }
        }
      }

      deprecatedApps = apps;
      console.log('Loaded deprecated apps:', deprecatedApps);
      return deprecatedApps;
    } catch (error) {
      console.error('Failed to load deprecated apps:', error);
      return {};
    }
  }

  // Check if an app card is for a deprecated app
  function getAppDeprecation(appName) {
    return deprecatedApps[appName];
  }

  // Get app name from card
  function getAppName(cardElement) {
    // Check if the card element itself is a link
    let href = null;

    if (cardElement.tagName === 'A' && cardElement.href) {
      href = cardElement.getAttribute('href');
    } else {
      // Otherwise look for a link inside the card
      const link = cardElement.querySelector('a[href*="/catalog/"]');
      if (link) {
        href = link.getAttribute('href');
      }
    }

    if (href) {
      const match = href.match(/\/catalog\/([^\/]+)\/?$/);
      if (match) {
        return match[1];
      }
    }

    return null;
  }

  // Add "DEPRECATED" badge to a card
  function addDeprecatedBadge(cardElement, deprecation) {
    // Check if badge already exists
    if (cardElement.querySelector('.deprecated-catalog-badge')) {
      return;
    }

    const scope = deprecation.scope;
    const daysRemaining = deprecation.daysRemaining;

    // Create badge element
    const badge = document.createElement('div');
    badge.className = `deprecated-catalog-badge ${scope}`;

    // Badge text based on scope
    if (scope === 'full') {
      badge.textContent = 'DEPRECATED';
    } else {
      // For partial, always show "PARTIAL" to indicate deprecation type
      badge.textContent = 'PARTIAL';
    }

    // Tooltip with days remaining and removal date
    const tooltipText = `${scope === 'full' ? 'App' : 'Feature'} will be removed in ${daysRemaining} days (${deprecation.removal_date})`;
    badge.title = tooltipText;

    // Add badge to card
    cardElement.style.position = 'relative';
    cardElement.appendChild(badge);

    // Mark card with data attributes
    cardElement.setAttribute('data-deprecated', 'true');
    cardElement.setAttribute('data-scope', scope);
  }

  // Apply deprecated badges to all catalog cards
  function processCatalogCards() {
    const cards = document.querySelectorAll('[class*="card"], [class*="app-"], .section-box, article');

    let processedCount = 0;
    cards.forEach(card => {
      const appName = getAppName(card);
      if (appName) {
        const appDeprecation = getAppDeprecation(appName);
        if (appDeprecation && appDeprecation.deprecations.length > 0) {
          const mostUrgent = getMostUrgentDeprecation(appDeprecation.deprecations);
          addDeprecatedBadge(card, mostUrgent);
          processedCount++;
        }
      }
    });

    if (processedCount > 0) {
      console.log(`Processed ${processedCount} deprecated app cards`);
    }
  }

  // Initialize
  async function init() {
    // Only run on the catalog listing page
    const path = window.location.pathname;
    if (!path.includes('/catalog') || path.match(/\/catalog\/[^\/]+\/?$/)) {
      console.log('Not on catalog listing page, skipping deprecated apps handler');
      return;
    }

    // Load deprecated apps list
    await loadDeprecatedApps();

    // Process cards initially
    processCatalogCards();

    // Watch for dynamically loaded cards (React app might load cards async)
    const observer = new MutationObserver(() => {
      processCatalogCards();
    });

    // Observe the catalog container for new cards
    const catalogContainer = document.querySelector('main, [class*="catalog"], [class*="grid"]');
    if (catalogContainer) {
      observer.observe(catalogContainer, {
        childList: true,
        subtree: true
      });
    }

    console.log('Catalog deprecated apps handler initialized');
  }

  // Run when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
