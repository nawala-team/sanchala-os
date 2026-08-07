// Copyright 2024 Sanchala OS Project
// SPDX-License-Identifier: MPL-2.0
// Fingerprint Protection Scripts for Sanchala Browser

#ifndef SANCHALA_BROWSER_SECURITY_FINGERPRINT_SCRIPTS_H_
#define SANCHALA_BROWSER_SECURITY_FINGERPRINT_SCRIPTS_H_

namespace sanchala {

// Canvas fingerprint protection - adds noise to canvas data
const char kCanvasProtectionScript[] = R"(
(function() {
  'use strict';
  const origToDataURL = HTMLCanvasElement.prototype.toDataURL;
  const origGetImageData = CanvasRenderingContext2D.prototype.getImageData;
  const noise = () => (Math.random() - 0.5) * 0.01;
  
  HTMLCanvasElement.prototype.toDataURL = function(...args) {
    const ctx = this.getContext('2d');
    if (ctx) {
      const img = ctx.getImageData(0, 0, this.width, this.height);
      for (let i = 0; i < img.data.length; i += 4) {
        img.data[i] = Math.max(0, Math.min(255, img.data[i] + noise() * 255));
      }
      ctx.putImageData(img, 0, 0);
    }
    return origToDataURL.apply(this, args);
  };
})();
)";

// WebGL fingerprint protection - masks GPU info
const char kWebGLProtectionScript[] = R"(
(function() {
  'use strict';
  const getParam = WebGLRenderingContext.prototype.getParameter;
  WebGLRenderingContext.prototype.getParameter = function(p) {
    if (p === 37445) return 'Sanchala Graphics';
    if (p === 37446) return 'Sanchala WebGL';
    return getParam.apply(this, arguments);
  };
  if (typeof WebGL2RenderingContext !== 'undefined') {
    WebGL2RenderingContext.prototype.getParameter = 
      WebGLRenderingContext.prototype.getParameter;
  }
})();
)";

// Audio fingerprint protection - adds noise to audio data
const char kAudioProtectionScript[] = R"(
(function() {
  'use strict';
  const origGetFloatFreq = AnalyserNode.prototype.getFloatFrequencyData;
  AnalyserNode.prototype.getFloatFrequencyData = function(arr) {
    origGetFloatFreq.apply(this, arguments);
    for (let i = 0; i < arr.length; i++) arr[i] += (Math.random()-0.5)*0.0001;
  };
})();
)";

// Hardware fingerprint protection - spoofs system info
const char kHardwareProtectionScript[] = R"(
(function() {
  'use strict';
  Object.defineProperty(navigator, 'hardwareConcurrency', {get: () => 4});
  Object.defineProperty(navigator, 'deviceMemory', {get: () => 8});
  Object.defineProperty(screen, 'width', {get: () => 1920});
  Object.defineProperty(screen, 'height', {get: () => 1080});
  delete navigator.getBattery;
})();
)";

// Font fingerprint protection - limits detectable fonts
const char kFontProtectionScript[] = R"(
(function() {
  'use strict';
  const allowed = ['Arial','Times New Roman','Courier New','Georgia','Verdana'];
  const origCheck = document.fonts.check.bind(document.fonts);
  document.fonts.check = function(font) {
    if (!allowed.some(f => font.includes(f))) return false;
    return origCheck(font);
  };
})();
)";

}  // namespace sanchala

#endif  // SANCHALA_BROWSER_SECURITY_FINGERPRINT_SCRIPTS_H_
