export class PageEventBus {
  private static instance: PageEventBus;
  private events: { [key: string]: Function[] } = {};

  private constructor() {}

  public static getInstance(): PageEventBus {
    if (!PageEventBus.instance) {
      PageEventBus.instance = new PageEventBus();
    }
    return PageEventBus.instance;
  }

  public subscribe(event: string, callback: Function): void {
    if (!this.events[event]) {
      this.events[event] = [];
    }
    this.events[event].push(callback);
  }

  public unsubscribe(event: string, callback: Function): void {
    if (!this.events[event]) return;
    this.events[event] = this.events[event].filter(cb => cb !== callback);
  }

  public publish(event: string, data?: any): void {
    if (!this.events[event]) return;
    this.events[event].forEach(callback => callback(data));
  }
}