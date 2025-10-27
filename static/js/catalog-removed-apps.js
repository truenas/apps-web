/**
 * Catalog Removed Apps Handler
 * Adds "REMOVED" badges and filtering for removed apps on the catalog page
 */

(function() {
  'use strict';

  let removedApps = [];
  let showRemovedApps = false;

  // Load removed apps data
  async function loadRemovedApps() {
    try {
      const response = await fetch('/data/app-removals.yaml');
      const yamlText = await response.text();

      // Parse YAML (simple parsing for this structure)
      const apps = {};
      const lines = yamlText.split('\n');
      let currentApp = null;

      for (const line of lines) {
        // Match app names (no leading whitespace, ends with colon)
        const appMatch = line.match(/^([a-z0-9_-]+):/);
        if (appMatch && !line.startsWith('#') && !line.startsWith(' ')) {
          currentApp = appMatch[1];
          apps[currentApp] = { name: currentApp };
        }
      }

      removedApps = Object.keys(apps);
      console.log('Loaded removed apps:', removedApps);
      return removedApps;
    } catch (error) {
      console.error('Failed to load removed apps:', error);
      return [];
    }
  }

  // Check if an app card is for a removed app
  function isRemovedApp(cardElement) {
    // Try to find app name from the card
    // Look for the link href which typically contains /catalog/app-name
    const link = cardElement.querySelector('a[href*="/catalog/"]');
    if (link) {
      const href = link.getAttribute('href');
      const match = href.match(/\/catalog\/([^\/]+)\/?$/);
      if (match) {
        const appName = match[1];
        return removedApps.includes(appName);
      }
    }

    // Fallback: check for app title
    const titleElement = cardElement.querySelector('[class*="title"], h2, h3, strong');
    if (titleElement) {
      const title = titleElement.textContent.trim().toLowerCase().replace(/\s+/g, '-');
      return removedApps.some(app => title.includes(app) || app.includes(title));
    }

    return false;
  }

  // Get app name from card
  function getAppName(cardElement) {
    const link = cardElement.querySelector('a[href*="/catalog/"]');
    if (link) {
      const href = link.getAttribute('href');
      const match = href.match(/\/catalog\/([^\/]+)\/?$/);
      if (match) {
        return match[1];
      }
    }
    return null;
  }

  // Add "REMOVED" badge to a card
  function addRemovedBadge(cardElement) {
    // Check if badge already exists
    if (cardElement.querySelector('.removed-catalog-badge')) {
      return;
    }

    // Create badge element
    const badge = document.createElement('div');
    badge.className = 'removed-catalog-badge';
    badge.textContent = 'REMOVED';
    badge.title = 'This app has been removed from the catalog';

    // Add badge to card (position in top-right corner)
    cardElement.style.position = 'relative';
    cardElement.appendChild(badge);

    // Mark card as removed for filtering
    cardElement.setAttribute('data-removed', 'true');

    // Try to update the icon to the one from removals.yaml
    updateCardIcon(cardElement);
  }

  // Store icon URLs from removals data
  let iconUrls = {};

  // Load icon URLs from removals data
  async function loadIconUrls() {
    try {
      const response = await fetch('/data/app-removals.yaml');
      const yamlText = await response.text();

      const lines = yamlText.split('\n');
      let currentApp = null;

      for (const line of lines) {
        // Match app name
        const appMatch = line.match(/^([a-z0-9_-]+):/);
        if (appMatch && !line.startsWith('#') && !line.startsWith(' ')) {
          currentApp = appMatch[1];
        }
        // Match icon URL
        else if (currentApp && line.match(/^\s+icon:\s*"(.+)"/)) {
          const iconMatch = line.match(/icon:\s*"(.+)"/);
          if (iconMatch) {
            iconUrls[currentApp] = iconMatch[1];
          }
        }
      }

      console.log('Loaded icon URLs:', iconUrls);
    } catch (error) {
      console.error('Failed to load icon URLs:', error);
    }
  }

  // Update card icon from removals data
  function updateCardIcon(cardElement) {
    const appName = getAppName(cardElement);
    if (!appName || !iconUrls[appName]) {
      console.log('No icon URL found for', appName);
      return;
    }

    const img = cardElement.querySelector('img');
    if (img) {
      const newIcon = iconUrls[appName];
      const currentSrc = img.src;

      // Update if it's the default icon or if it doesn't match the removal icon
      if (currentSrc.includes('default-icon') || !currentSrc.includes(appName)) {
        console.log(`Updating icon for ${appName} from ${currentSrc} to ${newIcon}`);
        img.src = newIcon;
        img.onerror = () => {
          console.warn(`Failed to load icon for ${appName}`);
        };
      } else {
        console.log(`Icon for ${appName} already set correctly: ${currentSrc}`);
      }
    }
  }

  // Apply removed badges to all catalog cards
  function processCatalogCards() {
    // Find all app cards (adjust selector based on actual HTML structure)
    const cards = document.querySelectorAll('[class*="card"], [class*="app-"], .section-box, article');

    let processedCount = 0;
    cards.forEach(card => {
      if (isRemovedApp(card)) {
        addRemovedBadge(card);
        processedCount++;

        // Hide by default if filter is off
        if (!showRemovedApps) {
          card.style.display = 'none';
        }
      }
    });

    console.log(`Processed ${processedCount} removed app cards`);
  }

  // Toggle visibility of removed apps
  function toggleRemovedApps(show) {
    showRemovedApps = show;
    const removedCards = document.querySelectorAll('[data-removed="true"]');

    removedCards.forEach(card => {
      card.style.display = show ? '' : 'none';
    });

    // Save preference
    localStorage.setItem('showRemovedApps', show);

    console.log(`Removed apps ${show ? 'shown' : 'hidden'}`);
  }

  // Add filter toggle to catalog page
  function addFilterToggle() {
    // Check if already added
    if (document.getElementById('show-removed-apps')) {
      console.log('Filter toggle already exists');
      return;
    }

    // Find filter controls - look for search input to insert after it
    const searchInput = document.querySelector('input[type="text"]');
    const selects = document.querySelectorAll('select');

    let insertionPoint = null;

    // Try to insert after the search input (at the end)
    if (searchInput) {
      insertionPoint = searchInput;
      console.log('Found insertion point after search box');
    } else if (selects.length > 0) {
      // Fallback: insert after the last select
      insertionPoint = selects[selects.length - 1];
      console.log('Found insertion point after last dropdown');
    } else {
      console.warn('Could not find suitable insertion point for filter toggle');
      return;
    }

    // Create simple inline toggle (no background, no border)
    const toggleContainer = document.createElement('span');
    toggleContainer.className = 'removed-apps-filter';
    toggleContainer.style.cssText = `
      display: inline-block;
      margin-left: 12px;
      margin-right: 12px;
    `;

    // Create checkbox
    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.id = 'show-removed-apps';
    checkbox.checked = showRemovedApps;
    checkbox.style.cssText = 'margin: 0; margin-right: 6px; cursor: pointer; vertical-align: middle;';
    checkbox.addEventListener('change', (e) => {
      toggleRemovedApps(e.target.checked);
    });

    // Create label
    const label = document.createElement('label');
    label.htmlFor = 'show-removed-apps';
    label.textContent = 'Show Removed';
    label.style.cssText = 'cursor: pointer; user-select: none; font-size: 0.9rem; vertical-align: middle;';

    toggleContainer.appendChild(checkbox);
    toggleContainer.appendChild(label);

    // Insert after the insertion point
    if (insertionPoint.nextSibling) {
      insertionPoint.parentNode.insertBefore(toggleContainer, insertionPoint.nextSibling);
    } else {
      insertionPoint.parentNode.appendChild(toggleContainer);
    }

    console.log('Added filter toggle to page');
  }

  // Initialize
  async function init() {
    // Only run on the catalog listing page, not individual app pages
    const path = window.location.pathname;
    if (!path.includes('/catalog') || path.match(/\/catalog\/[^\/]+\/?$/)) {
      console.log('Not on catalog listing page, skipping removed apps handler');
      return;
    }

    // Load saved preference
    const savedPref = localStorage.getItem('showRemovedApps');
    showRemovedApps = savedPref === 'true';

    // Load removed apps list and icon URLs
    await loadRemovedApps();
    await loadIconUrls();

    // Process cards initially
    processCatalogCards();

    // Add filter toggle
    addFilterToggle();

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

    console.log('Catalog removed apps handler initialized');
  }

  // Run when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
