let context = getContext(this);
const DESIGN_WIDTH = 360;
const DESIGN_HEIGHT = 780;

/**
 * Fits tools with different sizes and lengths
 */
export default class DimensionUtil {
  static adaptDimension(value: number): number {
    let deviceDisplay = globalThis.display;
    let widthScale = deviceDisplay.width / DESIGN_WIDTH;
    let virtualHeight = widthScale * DESIGN_HEIGHT;
    let designDim = Math.sqrt(DESIGN_WIDTH * DESIGN_WIDTH + DESIGN_HEIGHT * DESIGN_HEIGHT);
    let virtualDim = Math.sqrt(deviceDisplay.width * deviceDisplay.width + virtualHeight * virtualHeight);
    return virtualDim * value / designDim;
  }

  /**
   * Obtains the screen horizontal adaptation px.
   */
  static getPx(value: Resource): number {
    let beforeVp = context.resourceManager.getNumber(value.id);
    return this.adaptDimension(beforeVp);
  }

  /**
   * Obtains the screen horizontal adaptation vp.
   */
  static getVp(value: Resource): number {
    let beforeVp = context.resourceManager.getNumber(value.id);
    return px2vp(this.adaptDimension(beforeVp));
  }

  /**
   * Obtains the screen horizontal adaptation fp.
   */
  static getFp(value: Resource): number {
    let beforeFp = context.resourceManager.getNumber(value.id);
    return px2fp(this.adaptDimension(beforeFp));
  }
}