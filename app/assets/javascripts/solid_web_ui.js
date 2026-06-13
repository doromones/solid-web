// Live auto-refresh for the Solid* dashboards.
//
// Self-contained, dependency-free. Drives the controls rendered by
// SolidWebUi::Ui::RefreshControlsComponent: a frequency <select>, a countdown
// and a manual "refresh now" button. On each tick it reloads the dashboard's
// turbo-frame (morph, when Turbo is on the page) or falls back to fetch+replace.
//
// Linked via solid_web_ui_head_tags. Re-initialises on both DOMContentLoaded and
// turbo:load, idempotently, so it works in plain page loads and Turbo navigations.
(function () {
  "use strict";

  var TICK_MS = 250;

  function reloadFrame(frameId) {
    var frame = document.getElementById(frameId);
    if (!frame) return;
    var here = window.location.href;
    if (typeof frame.reload === "function") {
      // Real <turbo-frame>: point it at the current URL and reload (morphs when
      // the frame carries refresh="morph"). Setting src to a new value triggers a
      // fetch on its own; reload() forces one when the value is unchanged.
      if (frame.getAttribute("src") !== here) {
        frame.setAttribute("src", here);
      } else {
        frame.reload();
      }
      return;
    }
    // Fallback (no Turbo): fetch the page and swap the frame's contents.
    fetch(here, { headers: { "X-Requested-With": "XMLHttpRequest" }, credentials: "same-origin" })
      .then(function (r) { return r.text(); })
      .then(function (html) {
        var doc = new DOMParser().parseFromString(html, "text/html");
        var incoming = doc.getElementById(frameId);
        if (incoming) frame.innerHTML = incoming.innerHTML;
      })
      .catch(function () { /* transient network error — try again next tick */ });
  }

  function setup(panel) {
    if (panel.dataset.swuiRefreshReady === "1") return;
    panel.dataset.swuiRefreshReady = "1";

    var frameId = panel.dataset.frame;
    var storageKey = panel.dataset.storageKey;
    var select = panel.querySelector("[data-swui-refresh-select]");
    var status = panel.querySelector("[data-swui-refresh-status]");
    var nowBtn = panel.querySelector("[data-swui-refresh-now]");

    function readStored() {
      if (!storageKey) return null;
      try {
        var v = window.localStorage.getItem(storageKey);
        return v === null ? null : parseInt(v, 10);
      } catch (e) { return null; }
    }
    function store(v) {
      if (!storageKey) return;
      try { window.localStorage.setItem(storageKey, String(v)); } catch (e) { /* ignore */ }
    }

    // Initial interval: stored choice (if still offered) else the data default.
    var interval = readStored();
    if (interval === null || isNaN(interval)) interval = parseInt(panel.dataset.interval, 10) || 0;
    if (select) {
      var hasOption = Array.prototype.some.call(select.options, function (o) {
        return parseInt(o.value, 10) === interval;
      });
      if (hasOption) select.value = String(interval); else interval = parseInt(select.value, 10) || 0;
    }

    var nextAt = interval > 0 ? Date.now() + interval * 1000 : 0;

    function schedule() {
      nextAt = interval > 0 ? Date.now() + interval * 1000 : 0;
    }
    function refreshNow() {
      reloadFrame(frameId);
      schedule();
    }

    function render() {
      if (!status) return;
      if (interval <= 0) { status.textContent = "Auto-refresh off"; return; }
      if (document.hidden) { status.textContent = "Paused"; return; }
      var remaining = Math.max(0, Math.ceil((nextAt - Date.now()) / 1000));
      status.textContent = "Next refresh in " + remaining + "s";
    }

    if (select) {
      select.addEventListener("change", function () {
        interval = parseInt(select.value, 10) || 0;
        store(interval);
        schedule();
        render();
      });
    }
    if (nowBtn) {
      nowBtn.addEventListener("click", function () { refreshNow(); render(); });
    }
    document.addEventListener("visibilitychange", function () {
      if (!document.hidden && interval > 0 && Date.now() >= nextAt) refreshNow();
      render();
    });

    function tick() {
      if (interval > 0 && !document.hidden && Date.now() >= nextAt) refreshNow();
      render();
    }
    render();
    window.setInterval(tick, TICK_MS);
  }

  function init() {
    var panels = document.querySelectorAll("[data-swui-refresh]");
    Array.prototype.forEach.call(panels, setup);
  }

  document.addEventListener("DOMContentLoaded", init);
  document.addEventListener("turbo:load", init);
})();
